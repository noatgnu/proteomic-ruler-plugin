# Proteomic Ruler


## Installation

**[⬇️ Click here to install in Cauldron](http://localhost:42069/install?repo=https%3A%2F%2Fgithub.com%2Fnoatgnu%2Fproteomic-ruler-plugin)** _(requires Cauldron to be running)_

> **Repository**: `https://github.com/noatgnu/proteomic-ruler-plugin`

**Manual installation:**

1. Open Cauldron
2. Go to **Plugins** → **Install from Repository**
3. Paste: `https://github.com/noatgnu/proteomic-ruler-plugin`
4. Click **Install**

**ID**: `proteomic-ruler`  
**Version**: 0.1.0  
**Category**: analysis  
**Author**: Toan Phung

## Description

Estimate protein copy numbers and concentrations from deep profile mass spectrometry experiments using the Proteomic Ruler algorithm. Calculates copy numbers per cell, concentrations (nM), mass fractions, and mole fractions without spike-in standards.

## Runtime

- **Environments**: `python`

- **Entrypoint**: `ruler.py`

## Inputs

| Name | Label | Type | Required | Default | Visibility |
|------|-------|------|----------|---------|------------|
| `input_file` | Input Protein Intensities File | file | Yes | - | Always visible |
| `accession_id_col` | Accession ID Column Name | text | Yes | Protein.Ids | Always visible |
| `mw_column` | Molecular Weight Column Name | text | No | Mass | Always visible |
| `intensity_columns` | Intensity Columns | column-selector (multiple) | No | - | Always visible |
| `ploidy` | Ploidy Number | number (min: 1, max: 8, step: 1) | Yes | 2 | Always visible |
| `total_cellular` | Total Cellular Protein Concentration (pg/pL) | number (min: 50, max: 500, step: 10) | Yes | 200 | Always visible |
| `get_mw` | Fetch Molecular Weight from UniProt | boolean | No | false | Always visible |

### Input Details

#### Input Protein Intensities File (`input_file`)

Tab-separated or CSV file containing protein intensities and UniProt accession IDs


#### Accession ID Column Name (`accession_id_col`)

Column name containing UniProt accession IDs (e.g., Protein.Ids, Majority protein IDs)

- **Placeholder**: `Protein.Ids`

#### Molecular Weight Column Name (`mw_column`)

Column name containing molecular weight in kDa or Da (leave empty to fetch from UniProt)

- **Placeholder**: `Mass`

#### Intensity Columns (`intensity_columns`)

Select intensity columns for samples. If empty, auto-detects columns matching 'Intensity*' pattern


#### Ploidy Number (`ploidy`)

Ploidy of the organism (1=haploid, 2=diploid, 3=triploid, etc.)


#### Total Cellular Protein Concentration (pg/pL) (`total_cellular`)

Total cellular protein concentration in picograms per picoliter (typical: 200 pg/pL)


#### Fetch Molecular Weight from UniProt (`get_mw`)

Automatically fetch molecular weights from UniProt if not present in input file (requires internet connection)


## Outputs

| Name | File | Type | Format | Description |
|------|------|------|--------|-------------|
| `ruler_output` | `ruler_output.txt` | data | txt | Proteomic Ruler results with copy numbers, concentrations, and rankings |

## Requirements

- **Python Version**: >=3.11

## Usage

### Via UI

1. Navigate to **analysis** → **Proteomic Ruler**
2. Fill in the required inputs
3. Click **Run Analysis**

### Via Plugin System

```typescript
const jobId = await pluginService.executePlugin('proteomic-ruler', {
  // Add parameters here
});
```
