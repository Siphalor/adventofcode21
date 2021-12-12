#include <iostream>
#include <unordered_map>
#include <vector>
#include <fstream>
#include <cstring>

#include "nodes.h"

namespace part01 {
    void run(NodeMap* node_map);
}
namespace part02 {
    void run(NodeMap* node_map);
}

int main(int argc, char* argv[]) {
    if (argc != 3) {
        puts("incorrect number of arguments");
        return 1;
    }

    std::ifstream file;
    file.open(argv[2]);
    if (file.fail()) {
        puts("Failed to open file");
        return 2;
    }

    auto node_map = parse(file);

    if (strcmp(argv[1], "part01") == 0) {
        part01::run(node_map);
    } else if (strcmp(argv[1], "part02") == 0) {
        part02::run(node_map);
    }
    std::cout << "nodes: " << node_map->get_nodes().size() << std::endl;

    delete node_map;

    return 0;
}
