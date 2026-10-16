# RetinaXAI – Explainable AI for Diabetic Retinopathy Screening

## Project Overview
RetinaXAI is a MATLAB-based AI screening prototype designed to support diabetic retinopathy screening using retinal fundus images.

The system predicts the diabetic retinopathy severity grade and presents a Grad-CAM visualization to help users understand which image regions influenced the prediction.

## Key Features
- Retinal fundus image selection
- AI-based diabetic retinopathy severity prediction
- Five severity levels: Grade 0 to Grade 4
- Grad-CAM visualization for model explainability
- Basic image brightness and contrast assessment
- Screening report with prediction confidence and referral category

## Technology Used
- MATLAB
- Deep Learning Toolbox
- Image Processing Toolbox
- ResNet-18 model (as configured in the project)

## How to Run
1. Open MATLAB.
2. Place the required trained model file, `trainedNetFinal.mat`, in an accessible location.
3. Open `RETINAXAI_DEMO.m`.
4. Update the model file path in the `load(...)` statement if necessary.
5. Run the script and select a retinal fundus image when prompted.
6. View the generated screening report.

## Required Files
- `RETINAXAI_DEMO.m` — MATLAB screening demo.
- `trainedNetFinal.mat` — Required trained model file. It must contain the variable `trainedNetFinal`.

## Important Note
This project is a screening prototype and is not a medical diagnosis tool. Predictions require appropriate validation, and clinical decisions must be made by a qualified ophthalmologist.
