import gradio as gr
import numpy as np
import tensorflow as tf

# Load trained model
model = tf.keras.models.load_model("clean_skin_model.keras")

# Warm up graph once so first user click is not cold
_ = model(np.zeros((1, 224, 224, 3), dtype=np.float32), training=False)

def predict_skin(img):
    if img is None:
        return "No image provided."

    img = img.resize((224, 224))
    img_array = np.expand_dims(np.asarray(img, dtype=np.float32) / 255.0, axis=0)

    # Direct call is faster than model.predict() for single images
    prediction = float(model(img_array, training=False).numpy()[0][0])

    confidence = round((prediction if prediction > 0.5 else 1 - prediction) * 100, 2)

    if prediction > 0.5:
        return f"🔴 Malignant (Melanoma)\nConfidence: {confidence}%"
    else:
        return f"🟢 Benign (Nevus)\nConfidence: {confidence}%"

interface = gr.Interface(
    fn=predict_skin,
    inputs=gr.Image(type="pil", sources=["upload", "webcam"]),
    outputs="text",
    title="AI-Based Skin Cancer Detection",
    description="Upload a dermoscopic skin image to classify it as Benign or Malignant.\n\n⚠️ Disclaimer: This AI system is for educational purposes and not a medical diagnosis."
)

if __name__ == "__main__":
    interface.launch(server_name="0.0.0.0", server_port=7860)