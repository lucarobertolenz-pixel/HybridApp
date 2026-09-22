# Hybrid Athlete App

Persönliche iOS-App für Hybrid-Athleten (Kraft + Laufen) mit KI-Coach. Nicht für den App Store – nur für den privaten Gebrauch.

Fachliche Spezifikation: [`Docs/running.md`](Docs/running.md) (Coach-Logik), [`Docs/UpdateAgentRunning.md`](Docs/UpdateAgentRunning.md) (Analyse-Logik).

## Stand: Phase 1

Projekt-Setup, SwiftData-Datenmodell, HealthKit-Import, Laufliste. Läufe werden automatisch aus Apple Health importiert (inkl. Hintergrund-Update) und erscheinen im Tab **Heute**.

Nicht Teil von Phase 1: Zonen-Berechnung/Klassifikation, Krafttraining, Check-ins, KI-Coach, Apple-Watch-Übertragung – siehe Phasenplan unten.

## Projekt öffnen

1. `HybridApp.xcodeproj` in Xcode 16+ öffnen (macOS erforderlich – dieses Projekt wurde in einer Linux-Umgebung ohne Xcode erstellt und **nicht** lokal gebaut/getestet).
2. **Signing & Capabilities**: eigenes Apple-ID-Team auswählen. Die Capability *HealthKit* ist im Projekt bereits hinterlegt (`HybridApp/HybridApp.entitlements`); falls Xcode sie nicht automatisch erkennt, über „+ Capability“ → „HealthKit“ ergänzen.
3. Auf einem echten iPhone ausführen (HealthKit-Daten sind im Simulator nur eingeschränkt vorhanden – am besten Testdaten in der Health-App/dem Simulator manuell anlegen oder direkt auf dem Gerät testen).
4. Bei Erstlaunch fragt die App die HealthKit-Berechtigung an (nur Lesezugriff: Workouts, Herzfrequenz, Ruhepuls, HRV, Distanz, Route).

**Bundle-ID:** `com.lucarobertolenz.hybridapp` · **Minimales iOS-Ziel:** 18.0

## Warum kein XcodeGen / kein generiertes Projekt

Diese Umgebung hat kein Xcode/macOS – ich konnte das Projekt nicht kompilieren oder verifizieren. Auf Wunsch wurde bewusst eine **handgeschriebene `.xcodeproj`** gewählt (statt XcodeGen), um kein Zusatztool vorauszusetzen. Prüfe nach dem ersten Öffnen in Xcode kurz, ob die Build-Einstellungen (Signing, Deployment-Target) so passen, und melde dich bei Fehlern – Konfigurationsdetails lassen sich schnell nachziehen.

## Architekturprinzip

„Rechnen im Code, Denken im LLM.“ Alle Kennzahlen/Zonen/Warnsignale werden deterministisch in Swift berechnet (`Packages/AnalysisEngineKit`, ab Phase 2). Das LLM (Claude API) bekommt nur den fertig berechneten Athletenstatus und übernimmt Planung/Dialog (ab Phase 5). Kein Backend – alles läuft on-device, der Claude-API-Key wird im Keychain gespeichert.

**Hinweis zu den Mockups:** Die mitgelieferten MVP-Screens zeigen unter „Lauf-Detail“ eine Quellenangabe „via Strava“. Das widerspricht der Vorgabe, Strava aus lizenzrechtlichen Gründen nicht zu verwenden – die App nutzt ausschliesslich Apple HealthKit als Datenquelle (Garmin/Coros etc. synchronisieren dorthin).

## Projektstruktur

```
HybridApp/
├── HybridAppApp.swift        # App-Einstieg, SwiftData-ModelContainer
├── AppShell.swift             # TabView: Heute / Plan / Training / Fortschritt
├── Models/                    # SwiftData @Model (alle Entitäten, siehe unten)
├── HealthKit/                 # Autorisierung, Import, Hintergrund-Beobachtung
├── Features/                  # Ein Ordner pro Tab
├── DesignSystem/               # Theme (dunkel, minimalistisch)
├── Info.plist / HybridApp.entitlements
└── Assets.xcassets
Packages/AnalysisEngineKit/     # Eigenständiges Swift Package, Phase 2
Docs/                            # running.md, UpdateAgentRunning.md (Spezifikation)
```

## Datenmodell (SwiftData)

Alle Entitäten aus der Spezifikation sind bereits als `@Model`-Klassen angelegt (auch die, die erst in späteren Phasen befüllt werden), um spätere Migrationen zu vermeiden: `RunSession`, `Exercise`, `SetEntry`, `StrengthSession`, `CheckIn`, `ReferenceValues`, `Zones`, `PlannedWorkout`, `AthleteStatusSnapshot`, `Goal`. Aktiv genutzt in Phase 1: nur `RunSession`.

## Phasenplan

| Phase | Inhalt | Status |
|---|---|---|
| 1 | Projekt-Setup, Datenmodell, HealthKit-Import, Laufliste | ✅ diese Version |
| 2 | Analyse-Engine (`AnalysisEngineKit`) inkl. Unit-Tests, Dashboard mit Zonen/Trends | offen |
| 3 | Krafttraining erfassen und Fortschritt | offen |
| 4 | Check-ins, Warnsignale | offen |
| 5 | KI-Coach: Wochenplan (JSON) + Validierung + Chat | offen |
| 6 | WorkoutKit: Workouts auf die Apple Watch | offen |
| 7 | Automatische Neuplanung bei Signalen/verpassten Einheiten | offen |

## Bekannte Vereinfachungen in Phase 1 (werden in Phase 2 verfeinert)

- Splits werden grob aus Gesamtdistanz/-dauer in 1-km-Abschnitte gerechnet, nicht aus der echten GPS-Route. Pace-Ausreisser-Erkennung (> 20 % Abweichung) ist noch nicht aktiv.
- Herzfrequenzquelle (Handgelenk vs. Brustgurt) wird nur grob über den Gerätenamen geschätzt.
- Kein Onboarding-Flow; Health-Berechtigung wird beim ersten Öffnen des Tabs „Heute“ angefragt.
