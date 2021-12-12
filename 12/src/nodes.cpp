#include "nodes.h"

NodeMap* parse(std::istream &file) {
    auto* node_map = new NodeMap();
    std::string first;
    std::string second;
    while (true) {
        std::getline(file, first, '-');
        std::getline(file, second);
        if (file.fail()) {
            break;
        }
        node_map->add_connection(first, second);
    }
    return node_map;
}

NodeMap::NodeMap() = default;

void NodeMap::add_connection(const std::string& first, const std::string& second) {
    auto first_node = this->get_or_create_node(first);
    auto second_node = this->get_or_create_node(second);
    first_node->connections.insert(second_node);
    second_node->connections.insert(first_node);
}

Node* NodeMap::get_or_create_node(const std::string& name) {
    auto &node = this->nodes[name];
    if (node.name.empty()) {
        node.small = islower(name[0]);
        node.name = name;
    }
    return &node;
}

std::unordered_map<std::string, Node> &NodeMap::get_nodes() {
    return this->nodes;
}
