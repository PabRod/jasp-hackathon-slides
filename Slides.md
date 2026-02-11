---
theme: serif
bg: https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/insidebkg.png?raw=true
---
<!-- slide bg="https://github.com/PabRod/autodiff-slides/blob/main/_meta/_img/escience-cover.png?raw=true" -->
# JASP modules hackathon

By Dr. Pablo Rodríguez-Sánchez

note: this will be invisible in the slide
### Mind map
```mermaid
timeline
    title Structure
    Logistics    : Welcome
			     : Coffee
	Intro        : User experience
				 : R packages
				 : QML interfaces
	Setup        : R
                 : Dependencies
			     : Dev mode
			     : Personal access token
	The basics   : The template
				 : JASPBase
				 : GUI elements
	Advanced     : Plan for mistakes
				 : Version control
				 : Input control
				 : Error handling
				 : Submitting
	Hands-on
```

### Attendant's experience
```mermaid
graph TD

subgraph Intro
	User["User experience"] --> JASPapproach["JASP's approach"]
end

subgraph Setup
	InstallR["Install R"] & InstallJASP["Install JASP"] --> Dependencies --> Tricks --> GITHUB_PAT & DevMode & Renv
end

subgraph Basics["The basics"]
	Inside["Inside JASP"] --> JASPBase --> GUI["GUI elements"] --> Template
end

subgraph Advanced["Advanced"]
	Plan["Plan for mistakes"] --> Input["Input control"] --> Error["Error handling"] --> Submitting
end

Welcome --> Intro --> Setup --> Basics --> Advanced
```
## TODOs
```mermaid
graph TD
Install --"on"--> Windows & Ubuntu --> Document
```
---
## Before we start
+ Feel at home ☕
+ Get your copy of these slides at [pabrod.github.io/jasp-hackathon-slides](https://pabrod.github.io/jasp-hackathon-slides/)

--


[<img src="https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/who.png?raw=true">](https://jasp-stats.org/team/)

--

## Tell us about you

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/menti.png?raw=true)
[mentimeter.com](https://www.menti.com/alydqfpc8hh7)

code: 8930 8688

---
## Why JASP modules?
+ It's all about user experience
+ Coding vs. click and drag

--

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/R-screen.png?raw=true)

--

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/JASP-screen.png?raw=true)

--
![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/JASP-world.png?raw=true)

--
## Goals of this hackathon
+ ✔️ Help you with the first steps developing a JASP module
+ ❓  Plant the seeds of a future collaboration
+ ❌ Have a finished JASP module
---
## What is a JASP module?

A JASP module is an extension that adds new functionality to JASP

--

Many of the modules are directly accessible in the upper ribbon of JASP:

  

![](https://github.com/jasp-stats/jasp-desktop/raw/development/Docs/development/img/core-mods.png)

--
  

By pressing the `+` icon at the right-hand side of the screen, many more modules can be added to the ribbon.

--
  

![](https://github.com/jasp-stats/jasp-desktop/raw/development/Docs/development/img/extra-mods.png)

--

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/JASP-dev.png?raw=true)

--
### Coming soon!

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/store.png?raw=true)


---

# How to write a module?

--

## TL;DR

0. Install JASP and R
1. Download our module template
2. Install it using R
3. Load it in JASP as a developer module
4. Adapt it to your needs
5. Rinse and repeat


--


![](https://jasp-stats.org/wp-content/uploads/2025/11/JASPModulePuzzle.jpg)


--

## Folder structure

```sh
.
└── < An R package >
    └──inst
        ├── Description.qml    # Builds the ribbon menu
        ├── qml                # Folder containing one or more...
        │   └── analysis_1.qml # ... module's menus
        └── < optional stuff >

```

--

In detail

```sh
.
├── <module_name>.Rproj
├── DESCRIPTION             # Describes the package and lists its dependencies
├── LICENSE
├── NAMESPACE               # Controls function importing
├── R                       # Where the package functions live
│   └── functions.R
│   └── more-functions.R
│   └── ...
├── README.md
├── renv.lock               # (Optional) Environment management...
├── _processedLockFile.lock # ...files, controlled by package renv
├── tests/                  # (Optional) Unit tests
│
│  # === So far, this is just a standard R package ===
│  # === Interaction with JASP starts below === 
│ 
└──inst
    ├── Description.qml     # Builds the ribbon menu
    ├── Upgrades.qml        # Optional
    ├── qml                 # Folder containing one or more...
    │   └── analysis_1.qml  # ... module's menus
    │   └── ...
    ├── help                # (Optional) Module's help files
    │   └── ...
    └── icons               # (Optional) Module's icons
        ├── <module_name>.svg
        └── ...
```


--

![](https://github.com/jasp-stats/jaspModuleTemplate/raw/develop/inst/img/JASP.png?raw=true)

--

## `qml` example

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/detail-menu.png?raw=true)

--

```qml
Form {
  Text {
      text: qsTr("This analysis shows you different interface elements of JASP")
  }
	Group {
		title: qsTr("Logical controls")
		CheckBox {
			name: "my_tick_mark"
			label: qsTr("Tick mark")
			checked: false // Default value
		 }
		RadioButtonGroup {
			name: "radio_buttons"
			...
	}
```

--
#### Helicopter view
```mermaid

graph TD

R["R functions"] -- imported via --> NAMESPACE -- called by --> qmls["qml files"] -- to create--> Analyses

Analyses & help & icons & aesthetics["other aesthetics"] -- coordinated by --> Description.qml -- to create --> Menu["Graphical menu"]

```

--
#### Information flow

```mermaid
graph TD

description.qml --"contains one or more"--> Analyses --"pointing to a"--> qml[inst/qml/filename.qml] & func[R/filename.R#function_name]

func --with signature--> signature[jaspResults, dataset, options]

qml --that defines interactive objects--> name[name: obj_name] --that are passed to --> options[options$obj_name] --in--> signature --processes all and creates an--> output["User-friendly output"]


```

--
- Where
	- `jaspResults` creates the output
	- `dataset` can be input via `New Data` button
	- `options` are interactive objects available in the module

--
# Good news

You don't have to remember any of this. That's why we have a template!

[github.com/jasp-stats/jaspModuleTemplate](https://github.com/jasp-stats/jaspModuleTemplate)

--
## How to use the template

1. Just download or clone it
2. Add your desired R package(s) to `DESCRIPTION`
3. Adapt the template to your needs. For instance:
	1. Duplicate the elements you need more than once
	2. Remove the elements you don't need

--

### Tips and tricks
+ Think of scalability
+ Do not reinvent the wheel
+ Rely on the underlying R package as much as possible
+ Work mostly on the GUI, not on the functionality

--
### Tips and tricks
- Don't forget that each element lives in three files:

	- `inst/description.qml`
	- `inst/qml/<filename>.qml`
	- `R/<filename>.R`

--
### Tips and tricks
#### Where is my module?
If you forgot where your module was stored, just open R and type `.libPaths()`.

---

## Setup in a nutshell

Your system has to be able to:
- Install JASP  
- Install R packages
	- From source
	- From CRAN
	- From GitHub

--

## Check ✅
1. Download or clone [github.com/jasp-stats/jaspModuleTemplate](https://github.com/jasp-stats/jaspModuleTemplate)
2. Open it with RStudio
3. Go to the `Build` tab, and press `Install`
4. Didn't work? Take a look at the error message(s)

--
### Frequent problems
- [Rtools](https://cran.r-project.org/bin/windows/Rtools/) is required in Windows
- [tools](https://cran.r-project.org/bin/macosx/tools/) is required in mac
- Other system dependencies are:
	- `cmake`
	- `gcc-fortran`

--
### Frequent problems
`jaspTools`, `jaspGraphs` and `jaspBase` are hosted on GitHub, not on CRAN 

👇
Use `remotes`:

```r
remotes::install_github(c(
	"jasp-stats/jaspBase", 
	"jasp-stats/jaspGraphs", 
	"jasp-stats/jaspTools"))
``` 

--

### Frequent problems
I'm asked a `GITHUB_PAT`. 

👇
- Generate a new token in your GitHub.com account (`Your profile/Settings/Developer settings/Personal access tokens/Tokens (classic)`)
	- No need to tick any scope
	- No need for expiration date
- Set it as an environment variable in R

--

This happens because installing some of the jasp packages requires multiple calls to GitHub, which GitHub finds suspicious. So you need to identify yourself with a Personal Access Token.

--
### For Linux users
We pre-packed all the required dependencies in a flatpak package. Use the command below to install and run it:

```sh
flatpak run --branch=beta --devel org.jaspstats.JASP
```

Of course, if you prefer, you can install your dependencies yourself.

--
### For Linux users

The workflow is:

1. Edit your module in R studio
2. Execute `flatpak run --branch=beta --devel org.jaspstats.JASP` to open an R console there
3. `install.packages(<path to module>)` to install it from source
4. Refresh in JASP from the ribbon menu

--

### First goal of the day

0. Install JASP and R
1. Download our module template
2. Install it using R
3. Load it in JASP as a developer module
   
[github.com/jasp-stats/jaspModuleTemplate](https://github.com/jasp-stats/jaspModuleTemplate)

---
#### Reference materials

- These slides: [pabrod.github.io/jasp-hackathon-slides](https://pabrod.github.io/jasp-hackathon-slides/)
- [Curated background materials](https://github.com/jasp-stats/jasp-desktop/blob/development/Docs/development/jasp-background-materials.md)
- [Tutorial: Development of a JASP module](https://github.com/jasp-stats/jasp-desktop/blob/development/Docs/development/jasp-modules-tutorial.md)
- [Minimalistic git slides](https://nlesc-my.sharepoint.com/:p:/g/personal/p_rodriguez-sanchez_esciencecenter_nl/IQBmUMSGPb9JSKGnQxJlPopLAUAoEkZKLKImJAq3demD8D0?e=aVK5N1)

...

- [Detailed JASP module structure](https://github.com/jasp-stats/jasp-desktop/blob/development/Docs/development/jasp-module-structure.md)
- [JASP QML guide](https://github.com/jasp-stats/jasp-desktop/blob/development/Docs/development/jasp-qml-guide.md)
- [R Analyses guide](/Docs/development/r-analyses-guide.md) (or how to use `jaspResults`)


--
### We are here to help

![](https://github.com/PabRod/jasp-hackathon-slides/blob/main/img/qr.png?raw=true)  

[pabrod.github.io/jasp-hackathon-slides](https://pabrod.github.io/jasp-hackathon-slides)

