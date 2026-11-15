# Spec Delta

## ADDED Requirements

### Requirement: Status timelines
Status timelines SHALL use the `StatusTimeline` component from `packages/ui`. A reached step SHALL use the `primary` colour, a step not reached yet SHALL use `onSurfaceVariant`, and a failed step SHALL use the `error` colour. Step animations SHALL use the `long` motion token and SHALL be skipped when the platform asks to reduce motion.

#### Scenario: Step colours
- **WHEN** a timeline shows a reached step, a step not reached yet and a failed step
- **THEN** they use `primary`, `onSurfaceVariant` and `error`, and each pair passes the contrast test in both themes

#### Scenario: Motion setting
- **WHEN** the platform asks to reduce motion
- **THEN** a newly reached step appears without animation
