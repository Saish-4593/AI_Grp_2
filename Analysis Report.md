# ANALYSIS REPORT
## Mars Rover Sample Collection Planning Using PDDL

### 1. Introduction

The objective of this assignment is to model an autonomous Mars rover's sample collection mission using the Planning Domain Definition Language (PDDL). The rover, Curiosity, must collect geological samples from different exploration sites and transport them to the central research base.

The problem involves movement between connected locations, collection of soft and hard rocks, drill usage, and limited storage capacity. Two planning scenarios are considered. For each scenario, plans are generated using satisficing and improved search configurations, and their action sequences are compared.

### 2. Problem Description

The rover operates across seven locations: Base, SiteA, SiteB, SiteC, SiteD, SiteE and SiteF.

The initial scenario contains five rock samples:

| Rock | Type | Initial location |
|---|---|---|
| Rock1 | Soft | SiteA |
| Rock2 | Soft | SiteB |
| Rock3 | Hard | SiteC |
| Rock4 | Soft | SiteD |
| Rock5 | Hard | SiteF |

The rover has two storage bays, Bay1 and Bay2, and one drill, Drill1, initially located at SiteE. Soft rocks can be collected directly, whereas hard rocks require the rover to pick up the drill before collection.

Most routes are bidirectional. However, the route from SiteC to SiteD is one-way, and the rover cannot directly travel from SiteD to SiteC.

The required final state is:
- All rock samples must be delivered to Base.
- Both storage bays must be empty.
- The rover must return to Base.

### 3. PDDL Modelling and Planning Approach

The planning problem is represented using two PDDL files:

- **Domain.pddl:** Defines the types, predicates and available actions.
- **Problem.pddl:** Defines the objects, initial state and goal state.

The actions used in the domain are:

1. **Move:** Moves the rover between connected locations while respecting route direction.
2. **Pick Drill:** Allows the rover to collect the drill at its current location.
3. **Collect Soft:** Collects a soft rock into an empty storage bay.
4. **Collect Hard:** Collects a hard rock when the rover has the drill.
5. **Deposit:** Deposits a collected rock at the rover's current location and frees the storage bay.

Two planning configurations were considered:

- **Satisficing planning:** Searches for a feasible plan without necessarily minimizing its cost.
- **Improved planning:** Searches for better plans with respect to the planner's optimization objective.

The generated plans are compared using their number of actions and their ability to satisfy the mission requirements.

### 4. Scenario 1: Original Environment

In the first scenario, the rover must collect five rocks while all routes remain available.

#### 4.1 Satisficing Plan

The generated satisficing plan contains **33 actions**.

The rover first collects Rock1 from SiteA and Rock2 from SiteB, returning to Base to deposit each sample. It then travels through SiteA and SiteC to SiteE to collect the drill.

After acquiring the drill, the rover collects Rock3 from SiteC and Rock5 from SiteF. Rock4 is collected separately from SiteD. Each sample is transported back to Base and deposited.

The plan uses both storage bays during the mission, although the rocks are generally transported in separate trips.

#### 4.2 Improved Plan

The improved plan contains **32 actions**, one fewer than the satisficing plan.

The rover first collects Rock1 and Rock2 and deposits them at Base. It then travels to SiteE to collect the drill and proceeds to SiteF to collect Rock5.

After depositing Rock5 at Base, the rover collects Rock3 from SiteC. The route from SiteC to SiteD is used to reach SiteD and collect Rock4. The rover then returns through SiteB to Base.

This sequence combines some of the movements into a more compact route.

#### 4.3 Comparison

| Parameter | Satisficing | Improved |
|---|---:|---:|
| Number of actions | 33 | 32 |
| Rocks to collect | 5 | 5 |
| Drill required | Yes | Yes |
| Storage capacity | 2 bays | 2 bays |
| Final target | Base | Base |

The improved plan reduces the action count by one, approximately 3.03% compared with the satisficing plan.

An important observation is that the improved plan uses Bay1 for all the collections, leaving Bay2 unused. Therefore, although the rover has two storage bays available, the generated plan does not exploit the full carrying capacity.

The drill is collected at SiteE before the rover collects either of the hard rocks, Rock3 and Rock5.

### 5. Scenario 2: Extended Environment

The extended scenario introduces two additional samples and a route restriction.

The additional samples are:

| Rock | Type | Initial location |
|---|---|---|
| Rock6 | Soft | SiteE |
| Rock7 | Hard | SiteF |

A dust storm closes the route between Base and SiteB in both directions. Consequently, the rover must use alternative routes to reach SiteB and SiteD.

The goal is extended to require all seven rocks to be delivered to Base, with the rover returning to Base.

#### 5.1 Satisficing Plan

The generated satisficing plan contains **61 actions**.

The rover initially collects Rock1 from SiteA and deposits it at Base. Since the direct route between Base and SiteB is unavailable, the rover reaches SiteB through the alternative path:

**Base → SiteA → SiteC → SiteD → SiteB**

After collecting Rock2, the rover returns towards Base through SiteD, SiteE, SiteC and SiteA.

The rover subsequently visits SiteE to collect the drill, allowing it to collect the hard samples. Rock3 and Rock5 are collected from SiteC and SiteF, respectively.

Rock4 is collected from SiteD, Rock6 from SiteE, and Rock7 from SiteF. The plan ultimately returns the collected samples to Base.

The plan demonstrates how the rover can reach the affected locations by using the remaining connectivity in the environment.

#### 5.2 Improved Plan

The last generated improved plan contains **58 actions**.

The rover first collects Rock1 from SiteA and deposits it at Base. It then travels to SiteE, collects the drill and collects Rock6.

After returning to Base and depositing Rock6, it collects Rock3 from SiteC. The rover then travels through the one-way route from SiteC to SiteD and continues to SiteB to collect Rock2.

The plan also visits SiteD and SiteE to collect other samples and travels to SiteF to collect the hard rocks.

The route from SiteC to SiteD is particularly important because the direct Base–SiteB connection is closed. It provides an alternative way to reach SiteB and SiteD.

#### 5.3 Comparison

| Parameter | Satisficing | Improved |
|---|---:|---:|
| Number of actions | 61 | 58 |
| Rocks in the problem | 7 | 7 |
| Additional rocks | Rock6, Rock7 | Rock6, Rock7 |
| Direct Base–SiteB route | Closed | Closed |
| Alternative route | Used | Used |
| One-way route | Used | Used |

The improved plan has three fewer actions, corresponding to an approximately 4.92% reduction compared with the satisficing plan.

However, the final improved plan requires additional validation before it can be considered a valid solution. In particular, it contains deposit actions for Rock2 and Rock4 at SiteE rather than Base, followed by further collection actions involving these rocks. These actions do not establish that all seven rocks have reached Base in the final state.

Therefore, the action count of 58 represents the generated plan length, not proof that the extended goal has been satisfied.

### 6. Analysis of Storage Bays and Drill Usage

The two storage bays allow the rover to carry a maximum of two rocks at a time. A rock must be collected into an empty bay, and depositing it frees that bay for another sample.

In Scenario 1, the improved plan uses only Bay1, even though Bay2 is available. The satisficing plan uses both bays.

In Scenario 2, the satisficing plan uses both bays during the mission. The improved plan also refers to both bays, although its repeated collection and deposit actions require further checking.

The drill is initially located at SiteE in both scenarios. The rover must travel to SiteE and pick it up before collecting Rock3, Rock5 and Rock7, which are hard samples. Once picked up, the drill remains with the rover for the rest of the mission.

This makes the location of the drill an important factor in determining the rover's route and the order in which samples are collected.

### 7. Effect of the Dust Storm and One-Way Route

The extended scenario introduces a significant change in the movement network by closing the Base–SiteB connection in both directions.

The rover can no longer travel directly from Base to SiteB or return directly from SiteB to Base. Instead, it must use the alternative route through SiteA, SiteC and SiteD.

The one-way connection from SiteC to SiteD becomes particularly useful in this situation. It allows the rover to move towards SiteD and subsequently reach SiteB without violating the route constraints.

The route restriction therefore increases the complexity of the planning problem and requires the planner to find a different sequence of movements.

### 8. Overall Comparison and Observations

The action counts of the four generated plans are summarized below.

| Scenario | Planning configuration | Number of actions |
|---|---|---:|
| Scenario 1 | Satisficing | 33 |
| Scenario 1 | Improved | 32 |
| Scenario 2 | Satisficing | 61 |
| Scenario 2 | Improved | 58 |

The extended scenario requires more actions because two additional samples must be collected and the direct connection between Base and SiteB is unavailable.

In both scenarios, the improved configuration generates a plan with fewer actions than the corresponding satisficing configuration. However, a shorter action sequence does not by itself establish that a plan is globally optimal.

The extended improved plan also highlights the importance of checking the final state rather than relying only on the planner's reported plan. A valid plan must satisfy every goal condition, including the requirement that all rocks are deposited at Base.

### 9. Conclusion

The Mars Rover sample collection problem was represented using PDDL, with actions and constraints describing movement, sample collection, drill usage and storage capacity.

For the original environment, the improved plan contains 32 actions compared with 33 actions in the satisficing plan. For the extended environment, the corresponding generated plans contain 58 and 61 actions, respectively.

The extended scenario demonstrates how a planner can identify alternative routes when a connection becomes unavailable. In particular, the one-way SiteC-to-SiteD route provides an alternative path towards SiteB.

The results show that planning strategies can produce different action sequences and plan lengths for the same environment. They also demonstrate the importance of resource constraints, route connectivity and equipment availability in autonomous robotic planning.

Finally, the generated plans must be checked against the complete goal state using step-by-step simulation or a plan validator such as VAL. This is especially important for the extended improved plan, whose final action sequence contains deposit and collection operations that need correction or verification before the plan can be accepted as a valid solution.
