<template>
  <div class="portal-data">
    <div class="row align-items-center" style="background-color:#d1dbe5;margin-top:1em;">
      <h4 style="font-weight:800; padding-top:10px;padding-left:10px;">DATA EXPLORER: PROGRAM ON FORESTS</h4>
      <p style="font-style:italic;padding-left:10px;">This map illustrates the quantity of evidence existing for specific linkages and geographies, but does not illustrate direction of impact nor quality of evidence.</p>
    </div>
    <div class="row" style="margin-top:0.5em;">
      <div class="col-md-3">
        <div class="sticky-top" style="z-index:900; background-color:#ddd;">
          <h4>Summary</h4>
          <div style="background-color:white;">
            <summary-list :items="calculateSummary(filtered.data)"></summary-list>
          </div>
          <h4>Filters</h4>
          <div style="overflow:auto; min-height: 100px; max-height:60vh;">
            <filters  v-on:checked-nodes="checkHandler"></filters>
          </div>
        </div>
      </div>
      <div class="col-md-9 ml-md-auto">
        <Navbar></Navbar>
        <div class="row">
          <keep-alive>
            <router-view :fulldata="profordata" :filtered="filtered" :checkedfilters="checkedfilters"></router-view>
          </keep-alive>
        </div>
      </div>
    </div>
  </div>
</template>

<script>
  import {arrayeq} from './utils.js'

  import Navbar from '../components/Navbar.vue'
  import SummaryList from '../components/SummaryList.vue'
  import Filters from './components/Filters.vue'

  export default {
    props: ["fulldata","profordata"],
    components: {
      SummaryList,
      Filters,
      Navbar
    },
    data: function() {
      return {
        articles: [],
        checkedfilters: []
      }
    },
    computed: {
      filtered: function() {
        //if(this.checkedgeo.length > 0) {
          return {
            data: this.filterData(this.checkedfilters),
            filters_geo: this.checkedfilters.filter(dd=>dd.type==='geo').map(dd=>dd.name),
            filters_int: this.checkedfilters.filter(dd=>dd.type==='intervention').map(dd=>dd.type_code),
            filters_hab: this.checkedfilters.filter(dd=>dd.type==='habitat').map(dd=>dd.code),
            filters_out: this.checkedfilters.filter(dd=>dd.type==='outcome').map(dd=>dd.code),
            filters_study: this.checkedfilters.filter(dd=>dd.type==='study').map(dd=>dd.code),
            filters_comp: this.checkedfilters.filter(dd=>dd.type==='comparator').map(dd=>dd.code)
          }
        //}
      }
    },
    methods: {
      filterData: function(filters) {
        var geo = filters.filter(dd=>dd.type==='geo').map(dd=>dd.name); 
        var habitat = filters.filter(dd=>dd.type==='habitat').map(dd=>dd.code);
        var intervention = filters.filter(dd=>dd.type==='intervention').map(dd=>dd.type_code);
        var outcome = filters.filter(dd=>dd.type==='outcome').map(dd=>dd.code);
        var study = filters.filter(dd=>dd.type==='study').map(dd=>dd.code);
        var comp = filters.filter(dd=>dd.type==='comparator').map(dd=>dd.code);

        return this.profordata
          .filter(
            function(d) {
              var foundgeo =  d.geo.some(function(dd) {
                return geo.indexOf(dd.subregion) > -1
              })
              var foundhab = d.habitat.some(function(dd) {
                return habitat.indexOf(dd['Biome.']) > -1
              })
              var foundint = d.intervention.some(function(dd) {
                return intervention.indexOf(dd['Int_type']) > -1
              })
              var foundout = d.outcome.some(function(dd) {
                return outcome.indexOf(dd['Out_subtype']) > -1
              })
              var foundstudy = study.indexOf(d.study) > -1
              var foundcomp = d.comparator.some(function(dd) {
                return comp.indexOf(dd.Comps_type) > -1
              })
              return foundgeo && foundhab && foundint && foundout && foundstudy && foundcomp
                /*
                intervention.indexOf(d.Int_type) > -1 &&
                outcome.indexOf(d.Outcome) > -1
                */
            }
          )
      },
      checkHandler: function(checkednodes) {
        var allfilters = [].concat(checkednodes.filter(d=>d.colname==="subregion").map(d=>{return {type:'geo','id':d.id,'name':d.name}}))
          .concat(checkednodes.filter(d=>d.colname==="ecoregion").map(d=>{return {type:'habitat','id':d.id,'code':d.code}}))
          .concat(checkednodes.filter(d=>d.colname==="type").map(d=>{return {type:'intervention','id':d.id,'type_code':d.type_code}}))
          .concat(checkednodes.filter(d=>d.colname==="outcome").map(d=>{return {type:'outcome','id':d.id,'code':d.code}}))
          .concat(checkednodes.filter(d=>d.colname==="study").map(d=>{return {type:'study','id':d.id,'code':d.code}}))
          .concat(checkednodes.filter(d=>d.colname==="comparator").map(d=>{return {type:'comparator','id':d.id,'code':d.code}}))
        
        if(!arrayeq(this.checkedfilters, allfilters, function(d){return d.id})) {
          this.checkedfilters = allfilters
        }
      },
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
      },
      calculateSummary: function(data) {
        return [
          {
            title: "Total Articles",
            number: this.getArticleCount(data)
          }
        ]
      }
    }
  }
</script>

<style scoped>
  .card-title, .card-text {color:white;}
</style>
