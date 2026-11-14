# Quarter-Car Data Analysis

MATLAB scripts and sample data for exploring quarter-car suspension and damper measurements.

## Run the analysis

Open `main.m` in MATLAB and run it. The script reads the CSV in `csv/` and creates three figures:

- Suspension travel for the four wheel positions
- Damper velocity distributions
- Frequency spectra of suspension travel

The script locates the CSV relative to `main.m`, so it does not depend on MATLAB's Current Folder. If MATLAB is running a temporary copy of the script and cannot find the CSV next to it, a file picker will ask you to select the CSV.

The analysis uses the columns `Time_s`, the four `*_pot_travel_distance` signals, and the four `damper_vel_*` signals. The included dataset is `csv/2025-03-15_14-26-10_8_IIB.csv`.

## What the calculations mean

The CSV already contains damper velocity, so the script plots those values directly. For each corner, the velocity distribution is summarized as a probability histogram: each bin's count is divided by the total number of samples.

The FFT figure is calculated from each suspension travel signal. The script removes its mean, then computes the discrete Fourier transform. For a signal with `N` samples spaced by an average interval `dt`, the sample rate and frequency spacing are

```text
Fs = 1 / dt
df = Fs / N
f[k] = k * df
```

For interior positive-frequency bins, the one-sided amplitude is

```text
A[k] = 2 * |FFT(x)[k]| / N
```

The DC bin, and the Nyquist bin when `N` is even, are not doubled. The spectrum includes frequencies from zero up to the Nyquist limit (`Fs / 2`). This gives travel amplitude by frequency; the plotted amplitudes are not power or a power spectral density.

## Other scripts

The `functions/` directory contains helper and experimental scripts for signal plotting, damper analysis, suspension calculations, CSV export, and a quarter-car model. Some of these scripts expect MATLAB `.mat` data with particular signal structures and are separate from the CSV workflow in `main.m`.

`freqSignals.m` is a standalone sampling-frequency and PSD exploration script. Review its input filename before running it; it refers to a separate `.mat` dataset.
