<template>
  <div class="row" style="width:100%;">
    <collapse v-model="activeNames" class="col col-12">
      <collapse-item title = "Articles By Country" name="1">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-12">
            <VegaGeomap
              :spec = "spec_geo"
              :use-viewbox = "true"
              :use-tooltip = "true"
              :tooltip-options = "{
                showAllFields:false,
                fields: [
                  {
                    field: 'region',
                    title: 'Region'
                  },
                  {
                    field: 'subregion',
                    title: 'Subregion'
                  },
                  {
                    field: 'country',
                    title: 'Country'
                  },
                  {
                    field: 'size',
                    title: 'ArticleCount'
                  }
                ]
              }"
            >
            </VegaGeomap>
          </div>
        </div>
      </collapse-item>
      <collapse-item title="Intervention by Outcome Heatmap" name="2">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-8">
            <VegaHeatmap
              :matrix = "matrix_intout"
              x = "Intervention"
              y = "Outcome"
              z = "ArticleCount"
            >
            </VegaHeatmap>
          </div>
        </div>
      </collapse-item>
      <collapse-item title="Intervention by Region" name="3">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-12">
            <VegaBarFacet
              :matrix = "matrix_geoint"
              x = "ArticleCount"
              y = "Intervention"
              facet = "Region"
            >
            </VegaBarFacet>
          </div>
        </div>
      </collapse-item>
      <collapse-item title="Habitat by Region" name="4">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-12">
            <VegaBarFacet
              :matrix = "matrix_geohab"
              x = "ArticleCount"
              y = "Habitat"
              facet = "Region"
            >
            </VegaBarFacet>
          </div>
        </div>
      </collapse-item>
      <collapse-item title="Study Type by Comparator" name="5">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-12">
            <VegaBarFacet
              :matrix = "matrix_compstudy"
              x = "ArticleCount"
              y = "Comparator"
              facet = "StudyType"
            >
            </VegaBarFacet>
          </div>
        </div>
      </collapse-item>
      <collapse-item title="Intervention Combinations" name="6">
        <div class="row align-items-start" style="margin-top:2em;">
          <div class="col col-md-6">
            <VegaBar
              :matrix = "combo_int"
              x = "ArticleCount"
              y = "Intervention"
              style = "height: 300px;"
            >
            </VegaBar>
          </div>
          <!--div class="col col-md-6">
            <h5>Intervention Adjacency Matrix</h5>
            <VegaAdjMatrix
              style = "height:300px;"
              :network = "network_int"
            >
            </VegaAdjMatrix>
          </div-->
        </div>
      </collapse-item>
    </collapse>
  </div>
</template>

<script>
  import {set, nest, entries} from 'd3-collection'
  import {merge, ascending} from 'd3-array'

  import { Collapse, CollapseItem } from 'element-ui'
  import VegaGeomap from './VegaGeomap.vue'
  import VegaBarFacet from './VegaBarFacet.vue'
  import VegaBar from './VegaBar.vue'
  import VegaHeatmap from './VegaHeatmap.vue'
  import VegaAdjMatrix from './VegaAdjMatrix.vue'

  import Codes from '../codes.js'

  export default {
    components: {
      Collapse,
      CollapseItem,
      VegaGeomap,
      VegaBarFacet,
      VegaBar,
      VegaHeatmap,
      VegaAdjMatrix
    },
    props: ['fulldata', 'filtered', 'checkedfilters'],
    data: function() {
      return {
        activeNames: ['1', '2', '3', '4', '5', '6']
      }
    },
    computed: {
      spec_geo: function() {
        var filtered = this.filtered
        var data = filtered.data
        var geo = filtered.filters_geo
        var filtered_geo = []
        data.forEach(function(d) {
          d.geo.forEach(function(dd) {
            if(geo.indexOf(dd.subregion) > -1) {
              filtered_geo.push({
                id: dd.id,
                region: dd.region,
                subregion: dd.subregion,
                country: dd['Study_country.x'],
                aid: d.aid
              })
            }
          })
        })

        var nested = nest()
          .key(d=>d.id)
          .rollup(d=>{return {
            id: d[0].id,
            region: d[0].region,
            subregion: d[0].subregion,
            country: d[0].country,
            size: set(d.map(dd=>dd.aid)).size()
          }})
          .entries(filtered_geo);
        return {        
          "$schema": "https://vega.github.io/schema/vega/v3.0.json",
          "width": 500,
          "height": 450,
          "autosize": "fit",
          "background": "#ded",
          "config": {
            "axis": {
              "labelFont": "inherit",
              "titleFont": "inherit"
            },
            "legend": {
              "labelFont": "inherit",
              "titleFont": "inherit"
            }
          },
          "signals": [
            { "name": "tx", "update": "width / 2"},
            { "name": "ty", "update": "height / 2"},
            {
              "name": "scale",
              "value": 100,
              "on": [{
                "events": {"type": "wheel", "consume": true},
                "update": "clamp(scale * pow(1.0005, -event.deltaY * pow(16, event.deltaMode)), 100, 3000)"
              }]
            },
            {
              "name": "angles",
              "value": [0, 0],
              "on": [{
                "events": "mousedown",
                "update": "[rotateX, centerY]"
              }]
            },
            {
              "name": "cloned",
              "value": null,
              "on": [{
                "events": "mousedown",
                "update": "copy('projection')"
              }]
            },
            {
              "name": "start",
              "value": null,
              "on": [{
                "events": "mousedown",
                "update": "invert(cloned, xy())"
              }]
            },
            {
              "name": "drag", "value": null,
              "on": [{
                "events": "[mousedown, window:mouseup] > window:mousemove",
                "update": "invert(cloned, xy())"
              }]
            },
            {
              "name": "delta", "value": null,
              "on": [{
                "events": {"signal": "drag"},
                "update": "[drag[0] - start[0], start[1] - drag[1]]"
              }]
            },
            {
              "name": "rotateX", "value": 0,
              "on": [{
                "events": {"signal": "delta"},
                "update": "angles[0] + delta[0]"
              }]
            },
            {
              "name": "centerY", "value": 0,
              "on": [{
                "events": {"signal": "delta"},
                "update": "clamp(angles[1] + delta[1], -60, 60)"
              }]
            },

            { "name": "borderWidth", "value": 1 },
            { "name": "invert", "value": false }
          ],

          "projections": [
            {
              "name": "projection",
              "type": "mercator",
              "scale": {"signal": "scale"},
              "rotate": [{"signal": "rotateX"}, 0, 0],
              "center": [0, {"signal": "centerY"}],
              "translate": [{"signal": "tx"}, {"signal": "ty"}]
            }
          ],

          "data": [
            {
              "name": "geosum",
              "values": nested.map(d=>d.value)
            },
            {
              "name": "world",
              "url": "./static/world-110m.json",
              "format": {
                "type": "topojson",
                "feature": "countries"
              },
              "transform": [
                { 
                  "type": "lookup", "from": "geosum", "key": "id",
                  "fields": ["id"], "values": ["region", "subregion", "country", "size"]
                }//,
                //{ "type": "filter", "expr": "datum.size != null" }
              ]
            },
          ],

          "scales": [
            {
              "name": "color",
              "type": "sequential",
              "domain": {"data": "geosum", "field": "size"},
              "range": {"scheme": "bluegreen"},
              "zero": true
            }
          ],

          "marks": [
            {
              "type": "shape",
              "from": {"data": "world"},
              "encode": {
                "update": {
                  "strokeWidth": {"signal": "+borderWidth"},
                  "stroke": {"signal": "invert ? '#777' : '#bbb'"},
                  "fill": [
                    {
                      "test": "datum.size!==null",
                      "scale": "color",
                      "field": "size"
                    },
                    {"value": "lightgray"}
                  ],
                  "zindex": {"value": 0}
                },
                "hover": {
                  "strokeWidth": {"signal": "+borderWidth + 1"},
                  "stroke": {"value": "firebrick"},
                  "zindex": {"value": 1}
                }
              },
              "transform": [
                { "type": "geoshape", "projection": "projection" }
              ]
            }
          ],

          "legends": [
            {
              "fill": "color",
              "type": "gradient",
              "orient": "top-left",
              "title": "Count of Articles",
              "format": ",.0f"
            }
          ],

        }
      },
      matrix_geoint: function() {
        var filtered = this.filtered
        var data = filtered.data
        var geo = filtered.filters_geo
        var int = filtered.filters_int
        var filtered_geoint = []
        data.forEach(function(d) {
          d.geo.forEach(function(dd) {
            if(geo.indexOf(dd.subregion) > -1) {
              d.intervention.forEach(function(ddd){
                if(int.indexOf(ddd.Int_type) >  -1) {
                  var intervention = Codes().filter(dc => dc.code === ddd.int_group)[0]
                  filtered_geoint.push({
                    region: dd.region,
                    subregion: dd.subregion,
                    country: dd['Study_country.x'],
                    intervention: intervention ? intervention.code_def : ddd.int_group,
                    aid: d.aid
                  })
                }
              })
            }
          })
        })

        var nested = nest()
          .key(d=>d.region)
          .key(d=>d.intervention)
          .rollup(d=>{ return {
            Region: d[0].region,
            Intervention: d[0].intervention,
            //Description: Codes().filter(dc => dc.code=== d[0].int_group)[0].code_def,
            ArticleCount: set(d.map(dd=>dd.aid)).size()
          }})
          .entries(filtered_geoint)
          .map(d=>d.values.map(dd=>dd.value));
        return merge(nested)
      },
      matrix_geohab: function() {
        var filtered = this.filtered
        var data = filtered.data
        var geo = filtered.filters_geo
        var hab = filtered.filters_hab
        var filtered_geohab = []
        data.forEach(function(d) {
          d.geo.forEach(function(dd) {
            if(geo.indexOf(dd.subregion) > -1) {
              d.habitat.forEach(function(ddd){
                if(hab.indexOf(ddd['Biome.']) >  -1) {
                  var habitat = Codes().filter(dc => dc.code === ddd['Biome.'])[0]
                  filtered_geohab.push({
                    region: dd.region,
                    subregion: dd.subregion,
                    country: dd['Study_country.x'],
                    habitat: habitat ? habitat.code_def.split('-')[0] : ddd['Biome.'],
                    aid: d.aid
                  })
                }
              })
            }
          })
        })

        var nested = nest()
          .key(d=>d.region)
          .key(d=>d.habitat)
          .rollup(d=>{ return {
            Region: d[0].region,
            Habitat: d[0].habitat,
            //Description: Codes().filter(dc => dc.code=== d[0].int_group)[0].code_def,
            ArticleCount: set(d.map(dd=>dd.aid)).size()
          }})
          .entries(filtered_geohab)
          .map(d=>d.values.map(dd=>dd.value));
        return merge(nested)
      },
      matrix_intout: function() {
        var filtered = this.filtered
        var data = filtered.data
        var out = filtered.filters_out
        var int = filtered.filters_int
        var filtered_outint = []
        
        data.forEach(function(d) {
          d.intervention.forEach(function(dd) {
            if(int.indexOf(dd.Int_type) > -1) {
              d.outcome.forEach(function(ddd){
                if(out.indexOf(ddd.Out_subtype) >  -1) {
                  var intervention =  Codes().filter(dc => dc.code === dd.int_group)[0]
                  var outcome = Codes().filter(dc => dc.code === ddd.Out_subtype)[0]
                  filtered_outint.push({
                    outcome: outcome ? outcome.code_def : ddd.Out_subtype,
                    intervention: intervention ? intervention.code_def : dd.int_group,
                    aid: d.aid
                  })
                }
              })
            }
          })
        })

        var nested = nest()
          .key(d=>d.intervention)
          .key(d=>d.outcome)
          .rollup(d=>{
            return {
              Intervention: d[0].intervention,
              Outcome: d[0].outcome,
              ArticleCount: set(d.map(dd=>dd.aid)).size()
            }
          })
          .entries(filtered_outint)
          .map(d=>d.values.map(dd=>dd.value));

        return merge(nested)
      },
      matrix_compstudy: function() {
        var filtered = this.filtered
        var data = filtered.data
        var comp = filtered.filters_comp
        var study = filtered.filters_study
        var filtered_compstudy = []
        data.forEach(function(d) {
          d.comparator.forEach(function(dd) {
            if(comp.indexOf(dd.Comps_type) > -1 && study.indexOf(d.study) > -1) {
              var comparator = Codes().filter(dc => dc.code === dd.Comps_type)[0]
              var studytype = Codes().filter(dc => dc.code === d.study)[0]

              filtered_compstudy.push({
                comparator: comparator ? comparator.code_def : dd.Comps_type,
                studytype: studytype ? studytype.code_def : d.study,
                aid: d.aid
              })
            }
          })
        })

        var nested = nest()
          .key(d=>d.comparator)
          .key(d=>d.studytype)
          .rollup(d=>{ return {
            StudyType: d[0].studytype,
            Comparator: d[0].comparator,
            //Description: Codes().filter(dc => dc.code=== d[0].int_group)[0].code_def,
            ArticleCount: set(d.map(dd=>dd.aid)).size()
          }})
          .entries(filtered_compstudy)
          .map(d=>d.values.map(dd=>dd.value));
        return merge(nested)
      },
      combo_int: function() {
        var filtered = this.filtered
        var data = filtered.data
        var combinations = data.filter(function(d) {
          return d.intervention.length > 1
        }).map(function(d) {
          return d.intervention.map(function(dd,i) {
            return dd.Int_type
          }).sort(ascending).join(" | ")
        })

        var combo_hash = {};

        combinations.forEach(function(d,i) {
          combo_hash[d] = combo_hash[d] ? combo_hash[d] + 1 : 1
        })

        return entries(combo_hash).map(function(d) {
          return {"Intervention": d.key, "ArticleCount": d.value}
        }).sort(function(a,b) {
          return b.ArticleCount - a.ArticleCount
        })
      },
      network_int: function() {
        var filtered = this.filtered
        var data = filtered.data
        var nodes = {};
        var links = {};
        data.forEach(function(d) {
          var nnode = d.intervention.length
          d.intervention.forEach(function(dd) {
            nodes[dd.Int_type] = nodes[dd.Int_type] ? nodes[dd.Int_type] + 1 : 1
          })
          if(nnode > 1) {
            var int_arr = d.intervention.map(function(dd) {
              return dd.Int_type
            })
  
            int_arr.forEach(function(dd,i) {
              int_arr.slice(i+1).forEach(function(ddd) {
                if(links[[dd,ddd].join(",")]) {
                  links[[dd,ddd].join(",")] = links[[dd,ddd].join(",")] + 1
                  return
                }

                if(links[[ddd,dd].join(",")]) {
                  links[[ddd,dd].join(",")] = links[[ddd,dd].join(",")] + 1
                  return
                }
                
                links[[dd,ddd].join(",")] = 1
              })
            })
          }
        })

        return {
          nodes: entries(nodes).map(function(d,i) {
            var intervention = Codes().filter(dc => dc.code === d.key)[0]

            return {
              name: d.key,
              description: intervention ? intervention.code_def : d.key,
              ArticleCount: d.value
            }
          }),
          links: entries(links).map(function(d) {
            return {
              source: d.key.split(',')[0],
              target: d.key.split(',')[1],
              ArticleCount: d.value
            }
          })
        }
      }
    },
    methods: {
      getArticleCount: function(data) {
        if(Array.isArray(data)) {
          return data.length
        }
        return 0
      },
      getImpactCount: function(data) {
        if(Array.isArray(data)) {
          return data.filter(d=>d.IE === "Y").length
        }
        return 0
      },
      getOpenCount: function(data) {
        if(Array.isArray(data)) {
          return data.filter(d=>d.FullText === "Y").length
        }
        return 0
      }
    }
  }
</script>

<style>
  .el-collapse {
    border: none;
  }

  .el-collapse-item__wrap{
    background-color: #fff;
  }

  .vg-tooltip {
    visibility: hidden;
    padding: 6px;
    border-radius: 3px;
    position: fixed;
    z-index: 2000;
    font-family: sans-serif;
    font-size: 11px;

    /* The default look of the tooltip is the same as .light-theme
    but it can be overwritten by .dark-theme */
    background-color: rgba(255, 255, 255, 0.9);
    border: 1px solid #d9d9d9;
    color: black;
  }
  .vg-tooltip td.key, .vg-tooltip td.value {
    overflow: hidden;
    text-overflow: ellipsis;
  }
  .vg-tooltip td.key {
    color: #808080;
    max-width: 150px;
    text-align: right;
    padding-right: 1px;
  }
  .vg-tooltip td.value {
    max-width: 200px;
    text-align: left;
  }

  /* Dark and light color themes */
  .vg-tooltip.dark-theme {
    background-color: rgba(64, 64, 64, 0.9);
    border: none;
    color: white;
  }
  .vg-tooltip.dark-theme td.key {
    color: #bfbfbf;
  }
  .vg-tooltip.light-theme {
    background-color: rgba(255, 255, 255, 0.9);
    border: 1px solid #d9d9d9;
    color: black;
  }
  .vg-tooltip.light-theme td.key {
    color: #808080;
  }
</style>