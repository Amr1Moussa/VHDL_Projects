تمام، ده **README.md جاهز** ومنظم واحترافي، ومظبوط بالضبط على اللي كتبته، مع **أماكن فاضية للصور** 👌
انسخه زي ما هو وحطه داخل فولدر `Digital_VCO`.

---

````md
# Digital Square Wave VCO (VHDL)

<!-- ===================== -->
<!--   SCHEMATIC IMAGE     -->
<!-- ===================== -->
<!-- Place schematic image here -->
<!-- Example:
![Digital VCO Schematic](schematic.png)
-->

---

## Overview
This project implements a **Digital Voltage-Controlled Oscillator (VCO)** in **VHDL**.
The design generates a **50% duty-cycle square wave** with selectable output frequencies
based on a control word and a frequency range selector.

The design is fully synchronous and suitable for FPGA implementation.

---

## Ports

```vhdl
PORT (
    clk          : in  std_logic;              -- 1 MHz clock
    control_freq : in  std_logic_vector(2 downto 0); -- Frequency selection
    range        : in  std_logic;              -- 0: kHz, 1: Hz
    vco_out      : out std_logic               -- Square wave output
);
````

### Inputs

* **clk** → 1 MHz reference clock
* **control_freq[2:0]** → Selects frequency level
* **range** → Selects frequency range

  * `0` → kHz range
  * `1` → Hz range

### Output

* **vco_out** → Square wave output (50% duty cycle)

---

## Design Architecture

The VCO is divided into **three main blocks**:

---

## Block 1: Frequency Selector

### Purpose

Convert `(control_freq, range)` into a divider value **N**.

### Logic

* `control_freq` selects powers of two:

  * 2⁰, 2¹, … , 2⁷
* `range` scales the frequency:

  * `1` → kHz mode
  * `1000` → Hz mode

📌 **Divider Equation**

```
N = 2^(control_freq) × (1 or 1000)
```

📌 The output of this block is the divider value **N**, which controls the counter.

---

## Block 2: Counter

### Purpose

Count clock cycles until reaching **N**.

### Operation

* Clocked by `clk`
* Counts from `0` → `N − 1`
* When count reaches `N − 1`:

  * Counter resets to zero
  * Toggle signal is generated

---

## Block 3: Toggle Flip-Flop

### Purpose

Generate the square wave output.

### Operation

* Toggles its state every time the counter finishes
* Ensures a **50% duty cycle** automatically

---

## Internal Signals

### 1️⃣ Divider Value (N)

* Derived from `control_freq` and `range`
* Used by the counter
* Computed inside the **clocked process** to keep the design synchronous

**Type:** `integer`

---

### 2️⃣ Counter

* Counts from `0 → N − 1`
* Maximum divider value:

```
N_max = 2^7 × 1000 = 128000
```

Required counter width:

```
2^17 = 131072  → sufficient
```

**Type used:**

```vhdl
unsigned(16 downto 0)
```

---

### 3️⃣ Toggle Flip-Flop

* Output register that generates the square wave

**Type:**

```vhdl
out_reg : std_logic;
```

---

## Simulation Results

### Range = 0 (kHz Mode)

<!-- Place simulation image for range = 0 here -->

<!-- Example:
![Simulation - kHz Range](sim_khz.png)
-->

This simulation shows the **8 frequency levels** generated when `range = 0`.

---

### Range = 1 (Hz Mode)

<!-- Place simulation image for range = 1 here -->

<!-- Example:
![Simulation - Hz Range](sim_hz.png)
-->

This simulation shows the **8 frequency levels** generated when `range = 1`.

---

## Tools Used

* **Quartus Prime**
* **ModelSim**

---



```
