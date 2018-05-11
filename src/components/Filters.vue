<template>
  <div>
    <div>
      <tree
        ref = "filter_tree"
        :data="filters" :props="defaultProps"
        :default-checked-keys="filters.map(function(d){return d.id})"
        node-key="id"
        show-checkbox
        :expand-on-click-node = "false"
        @check-change="handleFilterChange"
      >
      </tree>
    </div>
  </div>
</template>

<script>
import { Tree } from 'element-ui'
import GeoFilters from '../geofilters.js'
import HabitatFilters from '../habitatfilters.js'
import InterventionFilters from '../interventionfilters.js'
import OutcomeFilters from '../outcomefilters.js'
import StudyFilters from '../studyfilters.js'
import CompFilters from '../compfilters.js'

export default {
  components: {
    Tree
  },
  data () {
    return {
      filters: [GeoFilters(), HabitatFilters(), InterventionFilters(), OutcomeFilters(), StudyFilters(), CompFilters()],
      defaultProps: {
        children: 'children',
        label: 'name'
      },
      checkedfilters: []
    }
  },
  mounted: function () {
    this.handleFilterChange()
  },
  methods: {
    handleFilterChange (data, checked, indeterminate) {
      this.checkedfilters = this.$refs.filter_tree.getCheckedNodes()
      this.$emit('checked-nodes', this.checkedfilters)
    }
  }
}
</script>



<style>
  .el-tree {
    border: none;
  }

  .el-tree-node {
    border-bottom: 1px solid rgba(0,0,0,.125);
  }

  .el-checkbox {margin-bottom: 0px;}

  .el-checkbox__input.is-indeterminate .el-checkbox__inner:before {
    content: "";
    position: absolute;
    display: block;
    border: 1px solid #fff;
    margin-top: -1px;
    left: 3px;
    right: 3px;
    top: 50%;
  }

  .el-checkbox__input.is-checked .el-checkbox__inner:after {
    transform: rotate(45deg) scaleY(1);
  }

  .el-checkbox__inner:after {
    box-sizing: content-box;
    content: "";
    border: 2px solid #fff;
    border-left: 0;
    border-top: 0;
    height: 8px;
    left: 5px;
    position: absolute;
    top: 1px;
    transform: rotate(45deg) scaleY(0);
    width: 4px;
    transition: transform .15s cubic-bezier(.71,-.46,.88,.6) .05s;
    transform-origin: center;
  }

  .el-checkbox__inner {
    display: inline-block;
    position: relative;
    border: 1px solid #bfcbd9;
    border-radius: 4px;
    box-sizing: border-box;
    width: 18px;
    height: 18px;
    background-color: #fff;
    z-index: 1;
    transition: border-color .25s cubic-bezier(.71,-.46,.29,1.46),background-color .25s cubic-bezier(.71,-.46,.29,1.46);
  }

  .el-checkbox__input.is-indeterminate .el-checkbox__inner {
    background-color: rgb(49, 105, 138);
    border-color: rgb(49, 105, 138);
  }

  .el-checkbox__input.is-checked .el-checkbox__inner {
    background-color: rgb(49, 105, 138);
    border-color: rgb(49, 105, 138);
  }

  .el-checkbox__original {
    opacity: 0;
    outline: none;
    position: absolute;
    margin: 0;
    width: 0;
    height: 0;
    left: -999px;
  }
</style>

