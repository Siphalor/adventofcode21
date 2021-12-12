#ifndef INC_12_NODES_H
#define INC_12_NODES_H

#include <iostream>
#include <unordered_map>
#include <unordered_set>
#include <vector>

const std::string START_NODE = std::string("start");
const std::string END_NODE = std::string("end");

class Node;
class NodeMap;

class Node {
public:
    std::unordered_set<Node*> connections;
    std::string name;
    bool small;
};

NodeMap* parse(std::istream &file);

class NodeMap {
public:
    NodeMap();
    void add_connection(const std::string& first, const std::string& second);
    Node* get_or_create_node(const std::string& name);
    std::unordered_map<std::string, Node>& get_nodes();
private:
    std::unordered_map<std::string, Node> nodes;
};
#endif //INC_12_NODES_H
