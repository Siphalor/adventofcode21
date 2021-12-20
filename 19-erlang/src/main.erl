-module(main).
-author("siphalor").
-export([main/2]).

main(part01, FilePath) ->
  Scanners_ = parse_file(FilePath),
  [First | Scanners] = lists:reverse(Scanners_),
  io:format("count: ~p~n", [length(combine_all(First, Scanners))]).

combine_all(Result, []) ->
  Result;

combine_all(Acc, New) ->
  io:format("acc: ~w, left: ~w~n", [length(Acc), length(New)]),
  {Res, New_} = combine_any_scanners(Acc, New, []),
  combine_all(Res, New_).

combine_any_scanners(_, [], _) ->
  error("no matches");

combine_any_scanners(KnownBeacons, [NewBeacons|NewRest], Checked) ->
  io:fwrite("next scanner\n"),
  case combine_scanners(KnownBeacons, KnownBeacons, NewBeacons) of
    next -> combine_any_scanners(KnownBeacons, NewRest, [NewBeacons | Checked]);
    ResBeacons -> {lists:append(ResBeacons, KnownBeacons), lists:append(Checked, NewRest)}
  end.

combine_scanners([], _, _) ->
  next;

combine_scanners([{B_BaseX, B_BaseY, B_BaseZ}| B_BaseRest], B_KnownBeacons, C_NewBeacons) ->
  R_KnownBeacons = lists:map(fun({BX, BY, BZ}) -> {BX - B_BaseX, BY - B_BaseY, BZ - B_BaseZ} end, B_KnownBeacons),
  case combine_scanners_find(R_KnownBeacons, C_NewBeacons, C_NewBeacons) of
    next -> combine_scanners(B_BaseRest, B_KnownBeacons, C_NewBeacons);
    New -> lists:map(fun({NX, NY, NZ}) -> {NX + B_BaseX, NY + B_BaseY, NZ + B_BaseZ} end, New)
  end.

combine_scanners_find(_, [], _) ->
  next;

combine_scanners_find(R_KnownBeacons, [{CX, CY, CZ} | C_NewRest], C_NewBeacons) ->
  R_NewBeacons = lists:map(fun({CNX, CNY, CNZ}) -> {CNX - CX, CNY - CY, CNZ - CZ} end, C_NewBeacons),
  case combine_scanners_find_coeff(R_KnownBeacons, R_NewBeacons, create_coefficients([
    { 1,  1,  1},
    { 1,  1, -1},
    { 1, -1,  1},
    { 1, -1, -1},
    {-1,  1,  1},
    {-1,  1, -1},
    {-1, -1,  1},
    {-1, -1, -1}
  ])) of
    next -> combine_scanners_find(R_KnownBeacons, C_NewRest, C_NewBeacons);
    New -> New
  end.

create_coefficients([]) -> [];

create_coefficients([{X, Y, Z} | BaseRest]) ->
  [
    {X, 0, 0, 0, Y, 0, 0, 0, Z},
    {X, 0, 0, 0, 0, Y, 0, Z, 0},
    {0, X, 0, 0, 0, Y, Z, 0, 0},
    {0, X, 0, Y, 0, 0, 0, 0, Z},
    {0, 0, X, Y, 0, 0, 0, Z, 0},
    {0, 0, X, 0, Y, 0, Z, 0, 0}
| create_coefficients(BaseRest)].

combine_scanners_find_coeff(_, _, []) ->
  next;

combine_scanners_find_coeff(R_KnownBeacons, R_NewBeacons, [{XX, XY, XZ, YX, YY, YZ, ZX, ZY, ZZ} | CoefficientRest]) ->
  RR_NewBeacons = lists:map(fun({RNX, RNY, RNZ}) -> {
    RNX * XX + RNY * YX + RNZ * ZX,
    RNX * XY + RNY * YY + RNZ * ZY,
    RNX * XZ + RNY * YZ + RNZ * ZZ
  } end, R_NewBeacons),
  {Matching, Unknown} = lists:partition(fun(R_New) -> lists:member(R_New, R_KnownBeacons) end, RR_NewBeacons),
  %if length(Matching) > 1 -> io:format("~p~n", [length(Matching)]); true -> 1 end,
  %io:format("~p ", [length(Matching)]),
  %io:format("~p : ~p~n", [length(Matching), length(Unknown)]),
  if
    length(Matching) >= 12 -> Unknown;
    true -> combine_scanners_find_coeff(R_KnownBeacons, R_NewBeacons, CoefficientRest)
  end.

parse_file(FilePath) ->
  {ok, File} = file:open(FilePath, [read]),
  read_scanners(File).

read_scanners(File) ->
  read_scanners(File, io:get_line(File, ''), []).

read_scanners(File, [45, 45 | _], Scanners) ->
  read_scanners(File, io:get_line(File, ''), [[] | Scanners]);


read_scanners(File, [10], Scanners) ->
  read_scanners(File, io:get_line(File, ''), Scanners);

read_scanners(_, eof, Scanners) ->
  Scanners;

read_scanners(File, Line, [Scanner|Scanners]) ->
  read_scanners(File, io:get_line(File, ''),
    [[list_to_tuple(lists:map(fun(Ele) -> {Int, _} = string:to_integer(string:trim(Ele)), Int end, string:tokens(Line, ","))) | Scanner] | Scanners]
  ).
