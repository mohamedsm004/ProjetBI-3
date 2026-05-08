from neo4j import GraphDatabase
import networkx as nx

URI = "neo4j://localhost:7687"
AUTH = ("neo4j", "password")

driver = GraphDatabase.driver(URI, auth=AUTH)

with GraphDatabase.driver(URI, auth=AUTH) as driver:
    driver.verify_connectivity()
