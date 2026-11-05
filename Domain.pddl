; Temporal PDDL domain for the Mars Rover sample collection problem.
; All action durations below are modelling assumptions because the assignment
; does not specify execution times. Time units are arbitrary and consistent.

(define (domain mars-rover)
  (:requirements :typing :durative-actions)

  (:types
    location rock bay drill
  )

  (:predicates
    (connected ?from - location ?to - location)
    (rover-at ?l - location)
    (rover-free)
    (drill-at ?d - drill ?l - location)
    (has-drill)
    (rock-at ?r - rock ?l - location)
    (soft ?r - rock)
    (hard ?r - rock)
    (bay-empty ?b - bay)
    (in-bay ?r - rock ?b - bay)
  )

  ; Travel between adjacent locations takes 2 time units.
  (:durative-action move
    :parameters (?from - location ?to - location)
    :duration (= ?duration 2)
    :condition (and
      (at start (rover-free))
      (at start (rover-at ?from))
      (at start (connected ?from ?to))
    )
    :effect (and
      (at start (not (rover-free)))
      (at start (not (rover-at ?from)))
      (at end (rover-at ?to))
      (at end (rover-free))
    )
  )

  ; Collecting the drill takes 1 time unit.
  (:durative-action pick-drill
    :parameters (?d - drill ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (rover-free))
      (at start (rover-at ?l))
      (at start (drill-at ?d ?l))
    )
    :effect (and
      (at start (not (rover-free)))
      (at start (not (drill-at ?d ?l)))
      (at end (has-drill))
      (at end (rover-free))
    )
  )

  ; Soft-rock collection takes 2 time units and does not require the drill.
  (:durative-action collect-soft
    :parameters (?r - rock ?l - location ?b - bay)
    :duration (= ?duration 2)
    :condition (and
      (at start (rover-free))
      (at start (soft ?r))
      (at start (rock-at ?r ?l))
      (at start (rover-at ?l))
      (at start (bay-empty ?b))
      (over all (rover-at ?l))
    )
    :effect (and
      (at start (not (rover-free)))
      (at start (not (rock-at ?r ?l)))
      (at start (not (bay-empty ?b)))
      (at end (in-bay ?r ?b))
      (at end (rover-free))
    )
  )

  ; Hard-rock collection takes 3 time units and requires the drill.
  (:durative-action collect-hard
    :parameters (?r - rock ?l - location ?b - bay)
    :duration (= ?duration 3)
    :condition (and
      (at start (rover-free))
      (at start (hard ?r))
      (at start (rock-at ?r ?l))
      (at start (rover-at ?l))
      (at start (has-drill))
      (at start (bay-empty ?b))
      (over all (rover-at ?l))
      (over all (has-drill))
    )
    :effect (and
      (at start (not (rover-free)))
      (at start (not (rock-at ?r ?l)))
      (at start (not (bay-empty ?b)))
      (at end (in-bay ?r ?b))
      (at end (rover-free))
    )
  )

  ; Deposit takes 1 time unit. The location parameter allows deposits anywhere;
  ; the problem goal requires every sample to be deposited at Base.
  (:durative-action deposit
    :parameters (?r - rock ?b - bay ?l - location)
    :duration (= ?duration 1)
    :condition (and
      (at start (rover-free))
      (at start (in-bay ?r ?b))
      (at start (rover-at ?l))
      (over all (rover-at ?l))
    )
    :effect (and
      (at start (not (rover-free)))
      (at start (not (in-bay ?r ?b)))
      (at end (bay-empty ?b))
      (at end (rock-at ?r ?l))
      (at end (rover-free))
    )
  )
)
