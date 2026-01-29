# Math Myth in SwiftUI 🧠📱

**Math Myth** is an interactive SwiftUI iOS project that visualizes famous math paradoxes, probability traps, and thought experiments — not with slides or formulas, but as **real, playable apps**.

Each “myth” is designed to challenge intuition first, then **prove what’s actually happening** through interaction, simulation, and visualization.

This repository accompanies the **Math Myth YouTube series**, where each episode breaks down one concept live inside the app.

---

## ✨ What’s inside

* Built entirely with **SwiftUI**
* Touch-first, visual explanations of classic math problems
* Playable experiments + large-scale simulations
* Designed for intuition → contradiction → understanding

---

## ✅ Implemented

### 🎯 Monty Hall Problem

The classic probability paradox — fully implemented and interactive.

**Features:**

* 3-door selection UI
* Correct host behavior (always reveals a goat)
* Stay vs. Switch decision flow
* Live win statistics
* Repeated simulation mode (10 → 10,000+ trials)
* Clear convergence to:

  * ~33% win rate when staying
  * ~66% win rate when switching

This serves as the **reference implementation** for how future Math Myth episodes are structured.

---

## 🚧 Coming Soon

Planned additions to the series include:

* **Birthday Paradox** — why probability explodes faster than intuition
* **Simpson’s Paradox** — when averages lie
* **Gambler’s Fallacy** — streaks, randomness, and false patterns
* **0.999… = 1** — an interactive proof
* **Zeno’s Paradox** — motion, infinity, and limits
* **Hilbert’s Hotel** — infinity as a UI problem

Each new myth will be added as a self-contained SwiftUI module following the same design principles.

---

## 🧩 Project Structure (high level)

* Reusable SwiftUI components for:

  * Simulations
  * Statistics & convergence
  * Step-based explanations
* Clear state machines for each experiment
* Separation between **play mode** and **simulation mode**

The goal is clarity, correctness, and reusability — not math jargon.

---

## 🛠 Requirements

* iOS 17+
* Xcode 15+
* SwiftUI

---

## 📄 License

MIT License

---

