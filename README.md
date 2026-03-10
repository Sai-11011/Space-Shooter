* **Feature**: Updated audio nodes to use `AudioStreamPlayer` instead of `AudioStreamPlayer2D` for improved compatibility
* **Bug Fix**: None
* **Chore**:
  * Adjusted volume levels for "Click", "Upgrade", and "BGM" audio nodes
  * Removed `max_distance` property from "BGM" node, as it's not applicable to `AudioStreamPlayer`
  * Updated unique IDs for "Click", "Upgrade", and "BGM" nodes
  * Removed unnecessary line from README.md file