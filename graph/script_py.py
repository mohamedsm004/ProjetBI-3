import networkx as nx
from neo4j import GraphDatabase
import community.community_louvain as community_louvain
import pandas as pd

uri = "bolt://localhost:7687"
user = "neo4j"
password = "password" # Remplace par ton mot de passe
driver = GraphDatabase.driver(uri, auth=(user, password))

def fetch_relationships(tx):
    query = """
    MATCH (c:Customer)-[r1]->(t:Transaction)-[r2:OCCURRED_AT]->(b:Branch)
    RETURN c.id AS source, b.name AS target
    UNION
    MATCH (c:Customer)-[r:BORROWED|HOLDS_CARD]->(type)
    RETURN c.id AS source, type.name AS target
    """
    result = tx.run(query)
    return [record.data() for record in result]

G = nx.Graph()

with driver.session() as session:
    results = session.execute_read(fetch_relationships)
    for record in results:
        G.add_edge(record["source"], record["target"])

partition = community_louvain.best_partition(G)

customer_data = []

with driver.session() as session:
    nodes = session.run("MATCH (c:Customer) RETURN c.id AS id")
    customer_ids = [record["id"] for record in nodes]

for node, community_id in partition.items():
    if node in customer_ids:
        customer_data.append({
            "customer_id": node,
            "community_id": community_id
        })

df = pd.DataFrame(customer_data)
df.to_csv("customer_communities.csv", index=False)

print(f"Analyse terminée. {len(df)} clients classés dans {len(df['community_id'].unique())} communautés.")
driver.close()