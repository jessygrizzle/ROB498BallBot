# LQR and MPC on a Ball Bot
Code base for final project in ROB 498 Applied Optimal Control at Umich by Joseph Taylor and Connor Williams in Winter '23.

## Code Layout
Main functions
- `runLQR` runs LQR on planar system. Generates output animation as `LQR_2D.mp4`. 
- `runLQR3D` runs LQR on full system. Generates output animation as `LQR_3D.mp4`.
- `runMPC` runs MPC on planar system. Generates output animation as `MPC_2D.mp4`.
- `runMPC3D` runs MPC on full system. Generates output animation as `MPC_3D.mp4`.

Helper functions
- `genfunctions` generates dynamics functions and functions for running MPC.
- `animate2D` animates planar system and writes .mp4 of animation. 
- `animate3D` animates full system and writes .mp4 of animation. 
- `transform_3D` generates transformation matrix from translation vector and Euler angles. Used by `animate3D`. 
- `modelValidation` simulates planar system from different initial conditions and plots output energies. 
- `modelValidation3D` simulates full system from different initial conditions and plots output energies.
- `calculateEnergies` calculates energies of planar system.

Generated functions
- `Hfunc` generates matrix for quadratic term in QP cost.
- `cfunc` generates vector for linear term in QP cost.
- `Afunc` generates inequality constraint matrix for QP constraints.
- `bfunc` generates inequality constraint vector for QP constraints.
- `Aeqfunc` generates equality constraint matrix for QP constraints. 
- `beqfunc` generates equality constraint vector for QP constraints. 
- `dynamfunc` state space dynamics function for ball bot.
