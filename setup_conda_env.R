# setup_conda_env.R
# Sets up or activates a conda environment for hybrid R + Python projects

library(reticulate)

env_name <- "quarto-env-conda"
required_pkgs <- c("pandas", "matplotlib", "wordcloud", "nltk")

# Create environment if it doesn't exist
if (!(env_name %in% conda_list()$name)) {
  message("Creating new conda environment: ", env_name)
  conda_create(env_name, packages = required_pkgs)
}

# Activate environment
use_condaenv(env_name, required = TRUE)

# Dynamic installer for later packages
ensure_python_package <- function(pkg, env = env_name) {
  current <- conda_list_packages(envname = env)$package
  if (!(pkg %in% current)) {
    message(sprintf("Installing Python package: '%s'", pkg))
    conda_install(envname = env, packages = pkg, pip = FALSE)
  }
}

# Export environment for reproducibility
export_conda_env <- function(env = env_name, file = "environment.yml") {
  conda_export(envname = env, filename = file)
}
