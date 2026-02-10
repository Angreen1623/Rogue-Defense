# Rogue-Defense

**A Top-Down Roguelite Tower Defense**

Rogue-Defense is a dynamic mix of Tower Defense strategy and Roguelite progression. Defend your central tower against radial waves of enemies, draft powerful upgrades between waves, and survive as long as you can.

## 🎮 Features (Implemented)

*   **Tower Defense Core**:
    *   **Static Tower**: The player controls a central defense tower that auto-targets incoming threats.
    *   **Radial Waves**: Enemies spawn in a circle around the tower and converge.
*   **Roguelite Elements**:
    *   **Data-Driven Enemies**: Stats are loaded from `Snapshot` resources, allowing for diverse enemy types.
    *   **Loop**: Fight -> Survive -> Upgrade (Coming Soon) -> Repeat.
*   **Architecture**:
    *   **ECS-Based**: Built using Entity-Component-System pattern for flexibility.
    *   **EventBus**: Decoupled architecture using global signals.
    *   **SnapshotLoader**: Automated loading of game resources.

## 📁 Project Structure

```
Rogue-Defense/
├── autoloads/           # Global Singletons (EventBus)
├── components/          # Reusable logic (Health, Movement, Combat)
├── entities/            # Game Objects (Player/Tower, Enemies, Projectiles)
├── systems/             # Managers (WaveManager, GameManager, SnapshotLoader)
├── resources/           # Data Definitions (EnemySnapshots)
├── mock/                # Legacy Data & Configs (Snapshot Persistence)
├── view/                # UI and Scenes
│   ├── ui/              # HUD, Menus
│   └── scenes/          # Levels (TestLevel.tscn)
└── tests/               # GUT Unit Tests
```

## 🚀 Getting Started

1.  **Open project in Godot 4.5+**.
2.  **Run the Test Scene**:
    *   Navigate to `view/scenes/TestLevel.tscn`.
    *   Press **F6** (Run Current Scene).
3.  **Gameplay**:
    *   Click "Start Wave" to spawn enemies.
    *   Watch your Tower defend itself!

## 🛠️ Systems Overview

*   **WaveManager**: Handles enemy spawning logic using `SnapshotLoader` data.
*   **GameManager**: Manages Win/Loss states and scene flow.
*   **SnapshotLoader**: Scans directories to load Enemy/Run configurations automatically.

---
*Based on the Cinicyde Architecture.*
