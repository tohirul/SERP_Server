from fastapi import FastAPI

from pandas import pandas as pd
from nltk.stem import PorterStemmer
from sklearn.feature_extraction.text import TfidfVectorizer
from sklearn.cluster import KMeans


app = FastAPI()


@app.get("/")
async def index():

    keyword_list = [
        "shoes",
        "shorts",
        "t-shirt",
        "shirt",
        "pants",
        "jeans",
        "dress",
        "skirt",
        "jacket",
        "coat",
    ]

    clustered_keywords_df = cluster_keywords(keyword_list, num_clusters=3)
    print(clustered_keywords_df)

    return {
        "name": "SERP Scraper",
        "version": "1.0.0",
        "message": "Server is running",
    }


def cluster_keywords(keywords, num_clusters=5):
    """
    Clusters a list of keywords using stemming and K-Means clustering.

    Args:
        keywords: A list of keywords (strings).
        num_clusters: The number of clusters to create.

    Returns:
        A pandas DataFrame with keywords and their assigned cluster labels.
    """
    stemmer = PorterStemmer()
    stemmed_keywords = [
        " ".join([stemmer.stem(word) for word in keyword.split()])
        for keyword in keywords
    ]
    print("Stemming keywords...", stemmed_keywords)

    vectorizer = TfidfVectorizer()
    vectorizer.set_params(stop_words="english")
    keyword_vectors = vectorizer.fit_transform(stemmed_keywords)
    print("Vectorizing keywords...", keyword_vectors)

    kmeans = KMeans(n_clusters=num_clusters, random_state=0, n_init=10)
    kmeans.fit(keyword_vectors)
    clusters = kmeans.labels_

    return pd.DataFrame({"keyword": keywords, "cluster": clusters})
