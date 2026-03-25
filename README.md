# C3 Game Jam: Short Food Supply Chain Resilience

A game exploring how Latvia's short food supply chains weathered COVID-19, based on *Usca et al., Resilience of Short Food Supply Chains During COVID-19*. Built in **Godot 4.6** (GDScript) for the C3 Spring Break Game Jam (HONR 299).

## About

Set in rural Latvia, you help Emilija organize food access for her community by placing **Distribution Points** (local farmer connections) and **Grocery Stores** (import based supply). The game progresses through Pre COVID and COVID-19 phases. As global imports stall and prices spike, local farmer networks prove more resilient, mirroring the paper's findings on Latvian short food supply chains during the pandemic.

At the end, you receive a personality based on your strategy:
- **The Locavore** favored local distribution points
- **The Capitalist** relied on grocery stores
- **The Survivor** thrived during the crisis
- **The Balanced Builder** mixed approach

Everything was built from scratch during the jam: original pixel art, sprite animations, background illustrations, music, sound design, dialog writing, and all game logic.

## Features

- **Two phase gameplay** Pre COVID normalcy transitions into COVID-19 disruption with shifting economics
- **Original art & animation** all sprites, characters, buildings, trucks, and backgrounds hand made
- **Original music & audio** custom main theme and COVID era track composed for the game
- **Upgrade tree** invest earnings into resilience or income upgrades
- **Dialog system** character driven narrative with Emilija, Hugo, and Farmer Zemnieks
- **Cutscenes** animated transitions between phases
- **Live stats dashboard** real time game stats pushed to Supabase, viewable via QR code
- **End game summary** detailed breakdown of spending, earnings, and food sold across phases

## Controls

| Key | Action |
|-----|--------|
| `Q` | Place Distribution Point |
| `E` | Place Grocery Store |
| `Click` | Confirm placement |
| `Esc` | Close menus |

## Running

1. Install [Godot 4.6](https://godotengine.org/)
2. Clone this repo
3. Open `project.godot` in Godot
4. Press Play

## Team

Built by Rohan Muppa, Iris Gong, Jack Smith, Jennifer Mezo, and Vimal Buckley.
