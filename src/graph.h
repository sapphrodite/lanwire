#ifndef GRAPH_H
#define GRAPH_H

#include <vector>
#include <cstdint>
#include <string>


struct Node {
    // TODO
};


enum class NodeType {
    Artist, Song, Album, Genre, None
};


struct Graph {

private:
    // Returns a list of all node IDs with a name matching the input string
    template <NodeType T>
    constexpr std::vector<size_t> find_matches(const std::string& name) {
        auto& nodes = get_node_array<T>();
        std::vector<size_t> matches;
        for (size_t i = 0; i < nodes.size(); i++) {
            if (nodes[i].get_name() == name) {
                matches.emplace_back(i);
            }
        }

        return matches;
    }

    // Iterate over construct node refs, appending node_id to the query list of each
    template <NodeType T>
    constexpr void append_to_crefs(size_t node_id, const std::vector<size_t>& cref_ids) {
        auto& node_array = get_node_array<T>();
        for (int i = 0; i < cref_ids.size(); i++) {
            size_t cref_id = cref_ids[i];
            constexpr NodeType next_type = (construct_ref_t[int(T)][i]);
            auto& ctr_node_array = get_node_array<next_type>();
            // TODO - actual append call once node class is written
        }

    }

    template <NodeType T>
    size_t new_node(const std::string& name) {
        auto& nodes = get_node_array<T>();
        size_t id = nodes.size();
        nodes.emplace_back(name);
        return id;
    }


    // dirty temporary hack for testing purposes

    template <NodeType T>
    struct TypeTag {};

    template <NodeType T>
    auto& get_node_array() { return node_array(TypeTag<T>()); }

    std::vector<Node>& node_array(TypeTag<NodeType::Artist>) { return artists; }
    std::vector<Node>& node_array(TypeTag<NodeType::Album>) { return albums; }
    std::vector<Node>& node_array(TypeTag<NodeType::Song>) { return songs; }
    std::vector<Node>& node_array(TypeTag<NodeType::Genre>) { return genres; }

    std::vector<Node> artists;
    std::vector<Node> albums;
    std::vector<Node> songs;
    std::vector<Node> genres;

    constexpr static NodeType construct_ref_t[4][4] = {
        {NodeType::Album},  // Artist
        {NodeType::Artist, NodeType::Genre}, // Song
        {NodeType::Song}, // Album
        {NodeType::None}}; // Genre

    constexpr static NodeType query_ref_t[4][4] = {
        {NodeType::None},  // Artist
        {NodeType::Album}, // Song
        {NodeType::Artist}, // Album
        {NodeType::Song}}; // Genre
};

#endif //GRAPH_H
