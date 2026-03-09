Here's a short, bulleted changelog for the code changes:
* **Feature**: Introduced a new acceleration and friction system for player movement, allowing for smoother and more realistic movement.
* **Feature**: Added a `delta` parameter to the `_physics_process` and `process_movement` functions to improve movement accuracy and responsiveness.
* **Feature**: Updated the player's `max_speed` calculation to use the `ship_data.speed.stat` value, allowing for more dynamic speed control.
* **Chore**: Updated the README.md file to include a changelog section, improving project documentation and transparency.
* **Chore**: Added a comment for testing automation in the README.md file, likely to facilitate debugging or automated testing processes.
* **Chore**: Refactored the `process_movement` function to use the `move_toward` method, simplifying the movement logic and improving code readability.