<template>
  <svg v-bind:style="styleObject" :viewBox=viewBox>
      <g>
        <TreemapNode
           v-for="(node, index) in nodes"
            v-bind:index="index"
            v-bind:key="node.id ? node.id : node.name"
            v-if="node.depth <= depth && node.depth > 0"
            v-bind:node="node"
            v-bind:colorScale="colorScale"
            v-bind:colorValueFun = "colorValueFun"
            v-bind:textValueFun = "textValueFun"
            v-bind:rectStyle="rectStyle"
        >
        </TreemapNode>
      </g>
  </svg>
</template>

<script>
import {hierarchy, treemap, treemapSquarify} from 'd3-hierarchy'
import {scaleOrdinal} from 'd3-scale'
import {schemeCategory10} from 'd3-scale'

import TreemapNode from './TreemapNode.vue'

export default {
  components: {
    TreemapNode
  },
  props: {
    tree: Object,
    sizefield: {
      type: String,
      default: 'size'
    },
    treewidth: {
      type: Number,
      default: 400
    },
    treeheight: {
      type: Number,
      default: 400
    },
    tile: {
      type: Function,
      default: treemapSquarify
    },
    depth: {
      type: Number,
      default: 2
    },
    colorScale: {
      type: [Function,Object],
      default: scaleOrdinal(schemeCategory10)
    },
    colorValueFun: {
      type: [Function,Object],
      default: function(d) {return d.parent.data.name}
    },
    textValueFun: {
      type: [Function,Object],
      default: function(d) {return d.data.name}
    },
    padding: {
      default: null
    },
    paddingTop: {
      default: null
    },
    paddingBottom: {
      default: null
    },
    paddingLeft: {
      default: null
    },
    paddingRight: {
      default: null
    },
    paddingInner: {
      default: null
    },
    paddingOuter: {
      default: null
    },
    styleObject: {
      type: Object,
      default: () => {return {height: '100%', width: '100%'}}
    },
    rectStyle: {
      type: Object,
      default: () => {return {}}
    },
    textStyle: {
      type: Object,
      default: () => {return {}}
    }
  },
  computed: {
    viewBox: function() {
      return '0,0,' + this.treewidth + ',' + this.treeheight;
    },
    treemap: function() { return this.calculate_tree() },
    nodes: function() {
      var color = this.color;
      var nodes = [];
      this.treemap.each(function(d) {
        nodes.push(d);
      });
      return nodes;
    }
  },
  methods: {
    calculate_tree: function() {
      var sizefield = this.sizefield;
      var d3t = hierarchy(this.tree)
        .sum(function(d) {
          return d[sizefield]
        });

      var tm = treemap()
        .size([this.treewidth, this.treeheight])
        .tile(this.tile)
        .round(true);
      
      ['padding','paddingTop','paddingBottom','paddingLeft','paddingRight','paddingOuter','paddingInner'].forEach(
        d => {if(this[d]){tm[d](this[d])}}
      )

      return tm(d3t)
    },
    onNodeClick: function(node) {
      this.$emit('node_click', node, this)
    }
  }
}
</script>
