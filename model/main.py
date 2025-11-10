import streamlit as st
import pandas as pd
import numpy as np
from joblib import load

kmeans = load("kmeans_best_model.pkl")

profiles = {
    0: "Usage intensif - risque élevé",
    1: "Activité faible - sobriété numérique",
    2: "Usage équilibré - faible risque",
    3: "Usage modéré - risque contrôlé"
}

st.title("Simulation du profil d'usage numérique")
# st.markdown(
#   "Ajuste les curseurs pour simuler une journée et obtenir ton profil prédictif.")

st.divider()

col1, col2 = st.columns(2)
with col1:
    screen_time = st.slider("Temps d'écran (minutes)", 0, 480, 60, 5)
    unlocks = st.slider("Nombre de déverrouillages", 0, 180, 30, 1)
with col2:
    short_sessions_ratio = st.slider(
        "Ratio de sessions courtes", 0.0, 1.0, 0.5, 0.01)
    night_minutes = st.slider(
        "Temps d'usage nocturne (minutes)", 0, 90, 5, 1)

screen_norm = min(screen_time / 240, 1)
unlocks_norm = min(unlocks / 90, 1)
night_norm = min(night_minutes / 30, 1)

new_day = pd.DataFrame({
    "screen_norm": [screen_norm],
    "unlocks_norm": [unlocks_norm],
    "short_sessions_ratio": [short_sessions_ratio],
    "night_norm": [night_norm]
})

st.markdown("Données normalisées")
st.dataframe(new_day, hide_index=True)

if st.button("Prédire le profil"):
    cluster = kmeans.predict(new_day)[0]
    profile = profiles[cluster]

    st.success(f"Profil prédit : {profile} (Cluster {cluster})")

    distances = kmeans.transform(new_day)[0]
    dist_df = pd.DataFrame({
        "Cluster": [0, 1, 2, 3],
        "Distance au centroïde": distances
    }).sort_values("Distance au centroïde")

    st.markdown("Distances aux centroïdes")
    st.dataframe(dist_df.set_index("Cluster"))

    st.bar_chart(dist_df.set_index("Cluster"))

st.divider()
# st.caption(
#   "Modèle KMeans basé sur des variables d'usage normalisées entre 0 et 1.")
