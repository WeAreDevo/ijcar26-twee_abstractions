// Cut-introduction harness: Prover9 proof -> Herbrand decomposition -> lemma.
//
// Run with (note: gapt.cli.CLIMain, NOT gapt.sh, and an ABSOLUTE proof path):
//   java -Xmx4g -Xss20m -cp gapt-2.19.0.jar gapt.cli.CLIMain cutintro.scala \
//        /abs/path/proof.out [method] [timeout_seconds]
//
// Everything is fully qualified on purpose: the script interpreter strips a
// leading `package` line, which breaks same-package references.
//
// Output is delimited KEY<TAB>VALUE lines so the Python side never parses
// GAPT's prose. Exit codes: 0 ok, 2 no lemma found, 3 timeout, 1 error.
//
// Landmines this works around (see PROGRESS_herbrand.md):
//  * CLIMain swallows exceptions and still exits 0 -> explicit try/catch+sys.exit
//  * Prover9 import shells out to `prooftrans`, which must be on PATH
//  * cut-introduction can run away -> withTimeout
//  * `os.Path` requires an absolute path

try {
  val proofFile = args(0)
  val methodName = if (args.length > 1) args(1) else "many_dtable"
  val timeoutSec = if (args.length > 2) args(2).toInt else 60

  val method: gapt.cutintro.GrammarFindingMethod = methodName match {
    case "many_dtable" =>
      gapt.grammars.DeltaTableMethod(singleQuantifier = false, subsumedRowMerging = true, keyLimit = Some(3))
    case "1_dtable_ss" =>
      gapt.grammars.DeltaTableMethod(singleQuantifier = true, subsumedRowMerging = true, keyLimit = None)
    case "1_maxsat"   => gapt.cutintro.MaxSATMethod(1)
    case "1_2_maxsat" => gapt.cutintro.MaxSATMethod(1, 2)
    case "reforest"   => gapt.cutintro.ReforestMethod
    case other        => println("ERROR\tunknown method: " + other); sys.exit(1)
  }

  val rp = gapt.provers.prover9.Prover9Importer.robinsonProof(
    gapt.formats.InputFile.fromPath(os.Path(proofFile)))
  val ip = gapt.cutintro.CutIntroduction.InputProof.fromResolutionProof(rp)

  println("FILE\t" + proofFile)
  println("METHOD\t" + methodName)
  // guessed, not hardcoded: equational problems need Equality or the extended
  // Herbrand sequent comes out unprovable
  println("BACKGROUND_THEORY\t" + ip.backgroundTheory)
  println("END_SEQUENT\t" + ip.expansionProof.shallow.toString.replace("\n", " "))

  val (termSet, encoding) = gapt.proofs.expansion.InstanceTermEncoding(ip.expansionProof)
  println("TERMSET_SIZE\t" + termSet.size)
  // A term set is "trivial" (paper's term) when every term has a distinct root
  // symbol -- each end-sequent formula instantiated once, so nothing to compress.
  val roots = termSet.map { case gapt.expr.Apps(hd, _) => hd }
  println("TERMSET_DISTINCT_ROOTS\t" + roots.size)

  val metrics = new gapt.utils.MetricsPrinter
  val solution =
    gapt.utils.LogHandler.use(metrics) {
      gapt.utils.withTimeout(scala.concurrent.duration.Duration(timeoutSec, "s")) {
        gapt.cutintro.CutIntroduction.compressToSolutionStructure(ip, method, useInterpolation = false)
      }
    }

  def emitMetrics(): Unit =
    metrics.data.toSeq.sortBy(_._1).foreach { case (k, v) =>
      println("METRIC\t" + k + "\t" + v.toString.replace("\n", " "))
    }

  solution match {
    case None =>
      println("STATUS\tNO_LEMMA")
      emitMetrics()
      sys.exit(2)
    case Some(s) =>
      println("STATUS\tOK")
      val grammar = gapt.cutintro.sehsToVTRATG(encoding, s.sehs)
      println("GRAMMAR_SIZE\t" + grammar.size)
      println("GRAMMAR_WSIZE\t" + grammar.weightedSize)
      println("GRAMMAR\t" + grammar.toString.replace("\n", " | "))
      println("NUM_CUTS\t" + s.cutFormulas.size)
      s.cutFormulas.zipWithIndex.foreach { case (f, i) =>
        println("LEMMA\t" + i + "\t" + f.toString.replace("\n", " "))
      }
      println("SEHS_SIZE\t" + s.sehs.size)
      println("SEHS_NUMVARS\t" + s.sehs.numVars)
      emitMetrics()
      sys.exit(0)
  }
} catch {
  case e: gapt.utils.TimeOutException =>
    println("STATUS\tTIMEOUT"); sys.exit(3)
  case e: Throwable =>
    println("STATUS\tERROR")
    println("ERROR\t" + e.getClass.getName + ": " + String.valueOf(e.getMessage).replace("\n", " "))
    sys.exit(1)
}
