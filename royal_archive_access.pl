
% Royal Archive Access Verification

% Step 1: Predicate Logic Representation

show_fol :-
    nl,
    writeln('Step 1: Predicate Logic Representation'),
    writeln('Rule 1: (Archivist(X) AND Verifies(X,R)) -> Trusted(X)'),
    writeln('Rule 2: (Trusted(X) AND Access(X,R) AND Sealed(R)) -> Permitted(X,R)'),
    writeln('Rule 3: (Inspects(X,R) AND FindsMark(X,R)) -> Verifies(X,R)'),
    writeln('Rule 4: Stored(R) -> Sealed(R)'),
    writeln('Fact 5: Stored(scroll_7)'),
    writeln('Fact 6: Access(mira,scroll_7)'),
    writeln('Fact 7: Inspects(mira,scroll_7)'),
    writeln('Fact 8: FindsMark(mira,scroll_7)'),
    writeln('Fact 9: Archivist(mira)'),
    writeln('Goal: Trusted(mira)').

% Step 2: Negation of Goal

show_negated_goal :-
    nl,
    writeln('Step 2: Negation of Goal'),
    writeln('Original goal: Trusted(mira)'),
    writeln('Negated goal: NOT Trusted(mira)').

% Step 3: Remove Implications

show_implication_removal :-
    nl,
    writeln('Step 3: Implication Removal'),
    nl,
    writeln('Rule 1:'),
    writeln('(Archivist(X) AND Verifies(X,R)) -> Trusted(X)'),
    writeln('NOT (Archivist(X) AND Verifies(X,R)) OR Trusted(X)'),
    writeln('NOT Archivist(X) OR NOT Verifies(X,R) OR Trusted(X)'),
    nl,
    writeln('Rule 2:'),
    writeln('(Trusted(X) AND Access(X,R) AND Sealed(R)) -> Permitted(X,R)'),
    writeln('NOT (Trusted(X) AND Access(X,R) AND Sealed(R)) OR Permitted(X,R)'),
    writeln('NOT Trusted(X) OR NOT Access(X,R) OR NOT Sealed(R) OR Permitted(X,R)'),
    nl,
    writeln('Rule 3:'),
    writeln('(Inspects(X,R) AND FindsMark(X,R)) -> Verifies(X,R)'),
    writeln('NOT (Inspects(X,R) AND FindsMark(X,R)) OR Verifies(X,R)'),
    writeln('NOT Inspects(X,R) OR NOT FindsMark(X,R) OR Verifies(X,R)'),
    nl,
    writeln('Rule 4:'),
    writeln('Stored(R) -> Sealed(R)'),
    writeln('NOT Stored(R) OR Sealed(R)').

% Step 4: Negation Movement

show_negation_movement :-
    nl,
    writeln('Step 4: Negation Movement'),
    writeln('Using De Morgan law: NOT (P AND Q) = NOT P OR NOT Q'),
    writeln('Rule 1: NOT Archivist(X) OR NOT Verifies(X,R) OR Trusted(X)'),
    writeln('Rule 2: NOT Trusted(X) OR NOT Access(X,R) OR NOT Sealed(R) OR Permitted(X,R)'),
    writeln('Rule 3: NOT Inspects(X,R) OR NOT FindsMark(X,R) OR Verifies(X,R)'),
    writeln('Rule 4: NOT Stored(R) OR Sealed(R)').

% Step 5: Standardization Apart

show_standardization :-
    nl,
    writeln('Step 5: Standardization Apart'),
    writeln('Rule 1 uses X1 and R1.'),
    writeln('Rule 2 uses X2 and R2.'),
    writeln('Rule 3 uses X3 and R3.'),
    writeln('Rule 4 uses R4.'),
    writeln('Variables in different rules are independent.').

% Step 6: Skolemization

show_skolemization :-
    nl,
    writeln('Step 6: Skolemization'),
    writeln('There are no existential quantifiers in the rules.'),
    writeln('No Skolem constants or functions are required.').

% Step 7: CNF Clauses
% p(...) is a positive literal; n(...) is a negative literal.

cnf(1, [n(archivist(X)), n(verifies(X,R)), p(trusted(X))]).
cnf(2, [n(trusted(X)), n(access(X,R)), n(sealed(R)),
        p(permitted(X,R))]).
cnf(3, [n(inspects(X,R)), n(finds_mark(X,R)), p(verifies(X,R))]).
cnf(4, [n(stored(R)), p(sealed(R))]).
cnf(5, [p(stored(scroll_7))]).
cnf(6, [p(access(mira,scroll_7))]).
cnf(7, [p(inspects(mira,scroll_7))]).
cnf(8, [p(finds_mark(mira,scroll_7))]).
cnf(9, [p(archivist(mira))]).
cnf(10, [n(trusted(mira))]).

show_cnf :-
    nl,
    writeln('Step 7: Final CNF Clauses'),
    writeln('C1: NOT Archivist(X) OR NOT Verifies(X,R) OR Trusted(X)'),
    writeln('C2: NOT Trusted(X) OR NOT Access(X,R) OR NOT Sealed(R) OR Permitted(X,R)'),
    writeln('C3: NOT Inspects(X,R) OR NOT FindsMark(X,R) OR Verifies(X,R)'),
    writeln('C4: NOT Stored(R) OR Sealed(R)'),
    writeln('C5: Stored(scroll_7)'),
    writeln('C6: Access(mira,scroll_7)'),
    writeln('C7: Inspects(mira,scroll_7)'),
    writeln('C8: FindsMark(mira,scroll_7)'),
    writeln('C9: Archivist(mira)'),
    writeln('C10: NOT Trusted(mira)').

% Step 8: Resolution

complement(p(X), n(X)).
complement(n(X), p(X)).

resolve(C1, C2, Result) :-
    select(L1, C1, Rest1),
    select(L2, C2, Rest2),
    complement(L1, L2),
    append(Rest1, Rest2, Temp),
    sort(Temp, Result).

print_literal(p(X)) :-
    write_term(X, [numbervars(true)]).

print_literal(n(X)) :-
    write('NOT '),
    write_term(X, [numbervars(true)]).

print_clause([]) :-
    write('[]').

print_clause([L|Rest]) :-
    print_literal(L),
    print_rest(Rest).

print_rest([]).

print_rest([L|Rest]) :-
    write(' OR '),
    print_literal(L),
    print_rest(Rest).

show_step(Name, Clause) :-
    write(Name),
    write(': '),
    print_clause(Clause),
    nl.

prove :-
    nl,
    writeln('Step 8: Resolution Refutation'),

    % Rule 3 and the inspection fact
    Rule3 = [n(inspects(X,R)),
             n(finds_mark(X,R)),
             p(verifies(X,R))],
    InspectFact = [p(inspects(mira,scroll_7))],
    resolve(Rule3, InspectFact, R1),
    show_step('R1', R1),

    % R1 and the hidden mark fact
    MarkFact = [p(finds_mark(mira,scroll_7))],
    resolve(R1, MarkFact, R2),
    show_step('R2', R2),

    % Rule 1 instantiated for Mira and scroll_7
    Rule1 = [n(archivist(mira)),
             n(verifies(mira,scroll_7)),
             p(trusted(mira))],
    ArchivistFact = [p(archivist(mira))],
    resolve(Rule1, ArchivistFact, R3),
    show_step('R3', R3),

    % R3 and the verification result
    resolve(R3, R2, R4),
    show_step('R4', R4),

    % R4 and the negated goal
    NegatedGoal = [n(trusted(mira))],
    resolve(R4, NegatedGoal, Final),
    show_step('Final resolvent', Final),

    nl,
    ( Final == [] ->
        writeln('Empty clause derived.'),
        writeln('Contradiction obtained.'),
        writeln('Therefore, Mira is trusted.')
    ;
        writeln('Proof failed.')
    ).

% Run all steps

verify :-
    show_fol,
    show_negated_goal,
    show_implication_removal,
    show_negation_movement,
    show_standardization,
    show_skolemization,
    show_cnf,
    prove.
