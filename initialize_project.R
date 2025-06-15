# initialize_project.R
# One-stop script to bootstrap a hybrid R + Python project
# Supports both R-only and R+Python workflows

# --- CONFIG ---
# --- initialize_project.R ---
# Hybrid R + Python environment setup

cat("👋 Hi! Welcome to your new project.\n")
cat("This workflow is designed for R–Python hybrid projects by default.\n")
cat("If you don’t plan to use Python, just type 'n'. Otherwise, press Enter to continue with Python support enabled.\n\n")

input <- readline("❓ Enable Python support? [Y/n] (default = Y): ")
use_python <- !(tolower(trimws(input)) == "n")

cat(sprintf("\n🔧 Python integration is %s.\n\n", ifelse(use_python, "ENABLED", "DISABLED")))

# ---- Safety check: must be in project root ----
required_files <- c("initialize_project.R", "setup_conda_env.R")
missing <- required_files[!file.exists(required_files)]
if (length(missing)) {
  stop("⚠️ Please open the project via the .Rproj file or set the working directory to the project root. Missing files: ", paste(missing, collapse = ", "))
}

# ---- 1. Install required R packages ----
required_r <- c("renv", "reticulate", "here")
installed_r <- rownames(installed.packages())

for (pkg in required_r) {
  if (!(pkg %in% installed_r)) {
    message("Installing R package: ", pkg)
    install.packages(pkg)
  }
}

# ---- 2. Initialize or restore renv environment ----
message("Setting up R environment with renv...")

library(renv)
if (file.exists("renv.lock")) {
  message("Found renv.lock file — restoring environment...")
  renv::restore()
} else {
  message("No renv.lock found — initializing new renv project...")
  renv::init(bare = TRUE)
}

# ---- 3. Optional: Set up Python via Conda ----
if (use_python) {
  message("Setting up Conda environment...")
  library(here)
  source(here::here("setup_conda_env.R"))
} else {
  message("Skipping Conda/Python setup (R-only mode)")
}

# ---- 4. Confirm wiring ----
message("Active R library path: ", .libPaths()[1])
if (use_python) {
  message("Active Python: ", reticulate::py_config()$python)
}

message("✅ Project initialized. You're ready to code!")


