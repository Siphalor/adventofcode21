#include "nodes.h"

namespace part01 {
    int count_connections(Node* end, std::unordered_set<const Node*> used_nodes);


    void run(NodeMap* node_map) {
        auto &nodes = node_map->get_nodes();
        auto *start = node_map->get_or_create_node(START_NODE);

        auto used_nodes = std::unordered_set<const Node*>(nodes.size());
        auto count = count_connections(start, used_nodes);
        std::cout << count << std::endl;
    }

    int count_connections(Node* node, std::unordered_set<const Node*> used_nodes) {
        int count = 0;
        used_nodes.insert(node);
        for (const auto &item : node->connections) {
            if (item->small && used_nodes.contains(item)) {
                continue;
            }
            if (item->name == END_NODE) {
                count++;
            } else {
                count += count_connections(item, used_nodes);
            }
        }
        return count;
    }
}
