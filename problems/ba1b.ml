open! Core

(* http://rosalind.info/problems/ba1b/ *)

let tally kmer map =
  let r = Map.find map kmer in
  match r with
  | None -> Map.set map ~key:kmer ~data:1
  | Some x -> Map.set map ~key:kmer ~data:(x + 1)
;;

let most_frequent map =
  Map.fold
    map
    ~init:(0, [])
    ~f:(fun ~key:kmer ~data:count (old_count, old_kmers) ->
      if count > old_count
      then count, [ kmer ]
      else if count = old_count
      then old_count, kmer :: old_kmers
      else old_count, old_kmers)
;;

let main text k =
  let rec loop i map =
    if i = String.length text - k
    then map
    else loop (i + 1) (tally (String.sub ~pos:i ~len:k text) map)
  in
  snd (most_frequent (loop 0 (Map.empty (module String))))
;;

let%expect_test "" =
  print_s
    [%sexp
      (List.rev
         (main
            "GTCGAAAAGCCAAGTCAACTTTCGCCGTCGAAAAGTAGACGGGAAGTTCAGAAGTTCAACTTTCGCCTAGACGGACTTTCGCCGTCGAAAAGGTCGAAAAGGAAGTTCACCAAGTCAGAAGTTCAGAAGTTCACCAAGTCAACTTTCGCCACTTTCGCCACTTTCGCCACTTTCGCCGAAGTTCATAGACGGTAGACGGTAGACGGTAGACGGGAAGTTCATAGACGGGTCGAAAAGGTCGAAAAGGTCGAAAAGGAAGTTCACCAAGTCAACTTTCGCCGTCGAAAAGCCAAGTCACCAAGTCACCAAGTCACCAAGTCAGTCGAAAAGGAAGTTCAGTCGAAAAGGTCGAAAAGGAAGTTCATAGACGGACTTTCGCCACTTTCGCCTAGACGGACTTTCGCCACTTTCGCCACTTTCGCCGAAGTTCATAGACGGTAGACGGGAAGTTCATAGACGGACTTTCGCCGAAGTTCAACTTTCGCCACTTTCGCCGAAGTTCAGTCGAAAAGACTTTCGCCGTCGAAAAGTAGACGGTAGACGGCCAAGTCAGAAGTTCAACTTTCGCCGTCGAAAAGACTTTCGCCCCAAGTCAACTTTCGCCTAGACGGCCAAGTCATAGACGGGAAGTTCAGAAGTTCAGAAGTTCAACTTTCGCCGTCGAAAAGGAAGTTCAGTCGAAAAGGAAGTTCAGTCGAAAAGGTCGAAAAGCCAAGTCACCAAGTCATAGACGGCCAAGTCATAGACGGGTCGAAAAGGTCGAAAAGGTCGAAAAGTAGACGGGTCGAAAAGGTCGAAAAGCCAAGTCAGTCGAAAAGGTCGAAAAGCCAAGTCAGAAGTTCACCAAGTCATAGACGGCCAAGTCAACTTTCGCC"
            12)
        : string list)];
  [%expect
    {|
    (AAAAGGTCGAAA AAAGGTCGAAAA AAGGTCGAAAAG CGAAAAGGTCGA GAAAAGGTCGAA
     GTCGAAAAGGTC TCGAAAAGGTCG) |}]
;;
