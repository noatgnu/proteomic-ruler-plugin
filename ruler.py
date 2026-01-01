#!/usr/bin/env python3
import click
from proteomicRuler.ruler import Ruler, add_mw
import pandas as pd
import sys


@click.command()
@click.option("--input", "-i", help="Input file containing intensity of samples and uniprot accession ids", type=click.Path(exists=True), required=True)
@click.option("--output", "-o", help="Output file", type=click.Path(), required=True)
@click.option("--ploidy", "-p", help="Ploidy of the organism", type=int, default=2)
@click.option("--total-cellular", "-t", help="Total cellular protein concentration", type=float, default=200)
@click.option("--mw-column", "-m", help="Molecular weight column name", type=str, default="Mass")
@click.option("--accession-id-col", "-a", help="Accession id column name", type=str, default="Protein.Ids")
@click.option("--intensity-columns", "-c", help="Intensity columns (comma-separated or multiple values)", type=str, multiple=True, default=None)
@click.option("--get-mw", "-g", help="Get molecular weight from uniprot", is_flag=True)
def main(input, output, ploidy, total_cellular, get_mw, mw_column="Mass", accession_id_col="Protein.Ids", intensity_columns=None):
    try:
        df = pd.read_csv(input, sep="\t")

        null_proteins = df[pd.isnull(df[accession_id_col])]
        if len(null_proteins) > 0:
            print(f"Warning: {len(null_proteins)} rows with null accession IDs will be removed", file=sys.stderr)

        df = df[pd.notnull(df[accession_id_col])]

        if len(df) == 0:
            raise ValueError(f"No valid rows found. Check accession ID column name: {accession_id_col}")

        if get_mw:
            print(f"Fetching molecular weights from UniProt...", file=sys.stderr)
            df = add_mw(df, accession_id_col)

        if intensity_columns is None or len(intensity_columns) == 0:
            intensity_columns = []
        else:
            intensity_columns = list(intensity_columns)

        if len(intensity_columns) > 0:
            print(f"Using {len(intensity_columns)} intensity columns: {', '.join(intensity_columns)}", file=sys.stderr)
        else:
            print(f"Auto-detecting intensity columns from file...", file=sys.stderr)

        print(f"Starting Proteomic Ruler analysis...", file=sys.stderr)
        print(f"Ploidy: {ploidy}", file=sys.stderr)
        print(f"Total cellular protein: {total_cellular} pg/pL", file=sys.stderr)
        print(f"MW column: {mw_column}", file=sys.stderr)
        print(f"Accession ID column: {accession_id_col}", file=sys.stderr)

        ruler = Ruler(df, intensity_columns, mw_column, accession_id_col, ploidy, total_cellular)
        ruler.df.to_csv(output, sep="\t", index=False)

        print(f"Analysis complete. Output written to: {output}", file=sys.stderr)

    except Exception as e:
        print(f"Error: {str(e)}", file=sys.stderr)
        sys.exit(1)


if __name__ == "__main__":
    main()
