# LQR and MPC on a Ball Bot
Code base for final project in ROB 498 Applied Optimal Control at Umich by Joseph Taylor and Connor Williams in Winter '23.

## Code Layout
Main functions
- `runLQR.m` runs LQR on planar system. Generates output animation as `LQR_2D.mp4`. 
- `runLQR3D.m` runs LQR on full system. Generates output animation as `LQR_3D.mp4`.
- `runMPC.m` runs MPC on planar system. Generates output animation as `MPC_2D.mp4`.
- `runMPC3D.m` runs MPC on full system. Generates output animation as `MPC_3D.mp4`.

Helper functions
- `genfunctions.m` generates dynamics functions and functions for running MPC.
- `animate2D.m` animates planar system and writes .mp4 of animation. 
- `animate3D.m` animates full system and writes .mp4 of animation. 
- `transform_3D.m` generates transformation matrix from translation vector and Euler angles. Used by `animate3D`. 
- `modelValidation.m` simulates planar system from different initial conditions and plots output energies. 
- `modelValidation3D.m` simulates full system from different initial conditions and plots output energies.
- `calculateEnergies.m` calculates energies of planar system.

Generated functions
- `Hfunc.m` generates matrix for quadratic term in QP cost.
- `cfunc.m` generates vector for linear term in QP cost.
- `Afunc.m` generates inequality constraint matrix for QP constraints.
- `bfunc.m` generates inequality constraint vector for QP constraints.
- `Aeqfunc.m` generates equality constraint matrix for QP constraints. 
- `beqfunc.m` generates equality constraint vector for QP constraints. 
- `dynamfunc.m` state space dynamics function for ball bot.
