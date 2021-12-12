#include "nodes.h"

namespace part02 {
    int count_connections(Node* end, std::unordered_set<const Node*> used_nodes, Node* double_node);

    void run(NodeMap* node_map) {
        auto &nodes = node_map->get_nodes();
        auto *start = node_map->get_or_create_node(START_NODE);

        auto used_nodes = std::unordered_set<const Node*>(nodes.size());
        auto count = count_connections(start, used_nodes, nullptr);
        std::cout << count << std::endl;
    }

    int count_connections(Node* node, std::unordered_set<const Node*> used_nodes, Node* double_node) {
        int count = 0;
        used_nodes.insert(node);
        for (const auto &item : node->connections) {
            if (item->name == END_NODE) {
                count++;
                continue;
            }
            if (item->small && used_nodes.contains(item)) {
                if (double_node == nullptr && item->name != START_NODE) {
                    count += count_connections(item, used_nodes, item);
                }
                continue;
            }
            count += count_connections(item, used_nodes, double_node);
        }
        return count;
    }
}
