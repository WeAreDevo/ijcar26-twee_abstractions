// Cheap probe: import a Prover9 proof and report term-set statistics only.
//
//   java -cp gapt-2.19.0.jar gapt.cli.CLIMain probe_termset.scala /abs/proof.out
//
// Cut-introduction's cost is gated by the term set, so this stops before the
// decomposition. Reports size, distinct root symbols (a term set is "trivial"
// when they are equal -- nothing to compress) and term depth, since depth
// rather than count is the suspected cost driver on our loop terms.

try {
  val proofFile = args(0)
  val rp = gapt.provers.prover9.Prover9Importer.robinsonProof(
    gapt.formats.InputFile.fromPath(os.Path(proofFile)))
  val ip = gapt.cutintro.CutIntroduction.InputProof.fromResolutionProof(rp)
  val (termSet, _) = gapt.proofs.expansion.InstanceTermEncoding(ip.expansionProof)

  def depth(e: gapt.expr.Expr): Int = e match {
    case gapt.expr.Apps(_, Seq())   => 1
    case gapt.expr.Apps(_, as)      => 1 + as.map(depth).max
    case _                          => 1
  }
  val roots = termSet.map { case gapt.expr.Apps(hd, _) => hd }
  val depths = termSet.toSeq.map(depth)

  println("PROBE_OK\t" + proofFile)
  println("TERMSET_SIZE\t" + termSet.size)
  println("TERMSET_DISTINCT_ROOTS\t" + roots.size)
  println("TERMSET_MAX_DEPTH\t" + (if (depths.isEmpty) 0 else depths.max))
  println("TERMSET_AVG_DEPTH\t" + (if (depths.isEmpty) 0.0 else depths.sum.toDouble / depths.size))
  println("BACKGROUND_THEORY\t" + ip.backgroundTheory)
  sys.exit(0)
} catch {
  case e: Throwable =>
    println("PROBE_FAIL\t" + e.getClass.getName + ": " + String.valueOf(e.getMessage).replace("\n", " "))
    sys.exit(1)
}
