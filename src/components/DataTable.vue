<template>
  <div style="padding-top:30px; width:100%;">
    <multiselect
      style="padding-bottom:10px;"
      v-model="value" :options="options"
      :multiple="true" :close-on-select="false" :clear-on-select="false" :hide-selected="true" :preserve-search="true"
      placeholder="Select columns" label="column" track-by="i"
    >
    </multiselect>
    <table></table>
  </div>
</template>

<script>
import Multiselect from 'vue-multiselect'

export default {
  components: {
    Multiselect
  },
  props: ["fulldata", "filtered", "checkedfilters"],
  data: function() {
    return {
      dt: null,
      value: null
    }
  },
  computed: {
    options: function() {
      if(this.filtered.data.length) {
        var columns = Object.keys(this.filtered.data[0]).map(function(ky, i) {
          return {
            i: i,
            column: ky
          }
        })

        // now add outlook details custom column
        return columns.concat([{
          i: columns.length,
          column: "Outcome Details"
        }])
      }
      return []
    }
  },
  methods: {
    renderTable: function(newFiltered) {
      var $ = window.$
      if(newFiltered.data.length && !this.dt) {
        var config = {
          data: newFiltered.data,
          lengthMenu: [[10, 25, 50, -1], [10, 25, 50, "All"]],
          columns: Object.keys(newFiltered.data[0]).map(function(col) {
            var title = col
            var render = null
            var type = null
            if(col === "aid") {
              type = "num"
            }
            if(col === "geo") {
              title = "Country"
              render = function(data, type, row, meta) {
                return data.map(function(d) {
                  return d["Study_country.x"]
                })
                .sort()
                .join(", ")
              }
            }
            if(col === "outcome") {
              title = "Outcome"
              render = function(data, type, row, meta) {
                return data.map(function(d) {
                  return d["Out_subtype"]
                })
                .sort()
                .join(", ")
              }
            }
            if(col === "intervention") {
              title = "Intervention"
              render = function(data, type, row, meta) {
                return data.map(function(d) {
                  return d["Int_type"]
                })
                .sort()
                .join(", ")
              }
            }
            if(col === "habitat") {
              title = "Habitat"
              render = function(data, type, row, meta) {
                return data.map(function(d) {
                  return d["Biome."]
                })
                .sort()
                .join(", ")
              }
            }
            if(col === "study") {
              title = "Study"
            }
            if(col === "comparator") {
              title = "Comparator"
              render = function(data, type, row, meta) {
                return data.map(function(d) {
                  return d["Comps_type"]
                })
                .sort()
                .join(", ")
              }
            }
            return {
              data: col,
              type: type,
              title: title,
              render: render
            }
          }),
          scrollX: true,
          scrollY: '60vh',
          responsive: true
        }

        config.columns.push({
          data: "outcome",
          type: 'string',
          title: 'Outcome Details',
          render: function(data, type, row, meta) {
            return ["<ul style='list-style: none;'>"]
              .concat(data.map(function(d, i) {
                return [
                  "<li><span style='font-weight: bold;'>Outcome " + (i+1) + "</span>",
                  "<ul style='list-style: none;'>"
                ].concat(
                  Object.keys(d).map(function(ky) {
                    return "<li><span style='font-weight: bold;'>" + ky + "</span>: " + d[ky] + "</li>"
                  })
                ).concat(["</ul></li>"])
                .join("\n")
              }))
              .concat(["</ul>"])
              .join("\n")
          }
        })

        this.dt = $('table', this.$el).DataTable(config)
        return
      }
      
      if(this.dt) {
        var dt = this.dt
        dt.clear()
        if(newFiltered.data.length) {
          dt.rows.add(newFiltered.data)
        }
        // Draw once all updates are done
        dt.draw(false)
      }
    },
    updateColumns: function() {
      if(!this.dt) { return }
      var dt = this.dt
      dt.columns().every(function(col) {
        dt.columns(col).visible(false, false)
      })

      dt.columns.adjust()

      if(this.value.length) {
        this.value.forEach(function(val) {
          dt.columns(val.i).visible(true, false)
        })
      }

      if(!this.value.length) {
        dt.columns().every(function(col) {
          dt.columns(col).visible(true, false)
        })
      }

      dt.columns.adjust().draw(false)
      $('.dataTables_scrollBody table',dt.table().container()).css({margin: 0})
    }
  },
  watch: {
    filtered: {
      handler: function(newFiltered) {
        this.renderTable(newFiltered)
      },
      deep: true
    },
    value: function(newColumns) {
      this.updateColumns()
    }
  },
  mounted: function() {
    this.renderTable(this.filtered)
  },
  beforeDestroy: function() {
    if(this.dt) {
      this.dt.destroy()
    }
  }
}
</script>

<style>
table.dataTable tbody td {vertical-align: top!important}
fieldset[disabled] .multiselect{pointer-events:none}.multiselect__spinner{position:absolute;right:1px;top:1px;width:48px;height:35px;background:#fff;display:block}.multiselect__spinner:after,.multiselect__spinner:before{position:absolute;content:"";top:50%;left:50%;margin:-8px 0 0 -8px;width:16px;height:16px;border-radius:100%;border-color:#41b883 transparent transparent;border-style:solid;border-width:2px;box-shadow:0 0 0 1px transparent}.multiselect__spinner:before{animation:a 2.4s cubic-bezier(.41,.26,.2,.62);animation-iteration-count:infinite}.multiselect__spinner:after{animation:a 2.4s cubic-bezier(.51,.09,.21,.8);animation-iteration-count:infinite}.multiselect__loading-enter-active,.multiselect__loading-leave-active{transition:opacity .4s ease-in-out;opacity:1}.multiselect__loading-enter,.multiselect__loading-leave-active{opacity:0}.multiselect,.multiselect__input,.multiselect__single{font-family:inherit;font-size:14px;-ms-touch-action:manipulation;touch-action:manipulation}.multiselect{box-sizing:content-box;display:block;position:relative;width:100%;min-height:40px;text-align:left;color:#35495e}.multiselect *{box-sizing:border-box}.multiselect:focus{outline:none}.multiselect--disabled{opacity:.6}.multiselect--active{z-index:1}.multiselect--active .multiselect__current,.multiselect--active .multiselect__input,.multiselect--active .multiselect__tags{border-bottom-left-radius:0;border-bottom-right-radius:0}.multiselect--active .multiselect__select{transform:rotate(180deg)}.multiselect--above.multiselect--active .multiselect__current,.multiselect--above.multiselect--active .multiselect__input,.multiselect--above.multiselect--active .multiselect__tags{border-top-left-radius:0;border-top-right-radius:0}.multiselect__input,.multiselect__single{position:relative;display:inline-block;min-height:20px;line-height:20px;border:none;border-radius:5px;background:#fff;padding:1px 0 0 5px;width:100%;transition:border .1s ease;box-sizing:border-box;margin-bottom:8px}.multiselect__tag~.multiselect__input,.multiselect__tag~.multiselect__single{width:auto}.multiselect__input:hover,.multiselect__single:hover{border-color:#cfcfcf}.multiselect__input:focus,.multiselect__single:focus{border-color:#a8a8a8;outline:none}.multiselect__single{padding-left:6px;margin-bottom:8px}.multiselect__tags-wrap{display:inline}.multiselect__tags{min-height:40px;display:block;padding:8px 40px 0 8px;border-radius:5px;border:1px solid #e8e8e8;background:#fff}.multiselect__tag{position:relative;display:inline-block;padding:4px 26px 4px 10px;border-radius:5px;margin-right:10px;color:#fff;line-height:1;background:#41b883;margin-bottom:8px;white-space:nowrap}.multiselect__tag-icon{cursor:pointer;margin-left:7px;position:absolute;right:0;top:0;bottom:0;font-weight:700;font-style:normal;width:22px;text-align:center;line-height:22px;transition:all .2s ease;border-radius:5px}.multiselect__tag-icon:after{content:"\D7";color:#266d4d;font-size:14px}.multiselect__tag-icon:focus,.multiselect__tag-icon:hover{background:#369a6e}.multiselect__tag-icon:focus:after,.multiselect__tag-icon:hover:after{color:#fff}.multiselect__current{min-height:40px;overflow:hidden;padding:8px 12px 0;padding-right:30px;white-space:nowrap;border-radius:5px;border:1px solid #e8e8e8}.multiselect__current,.multiselect__select{line-height:16px;box-sizing:border-box;display:block;margin:0;text-decoration:none;cursor:pointer}.multiselect__select{position:absolute;width:40px;height:38px;right:1px;top:1px;padding:4px 8px;text-align:center;transition:transform .2s ease}.multiselect__select:before{position:relative;right:0;top:65%;color:#999;margin-top:4px;border-style:solid;border-width:5px 5px 0;border-color:#999 transparent transparent;content:""}.multiselect__placeholder{color:#adadad;display:inline-block;margin-bottom:10px;padding-top:2px}.multiselect--active .multiselect__placeholder{display:none}.multiselect__content-wrapper{position:absolute;display:block;background:#fff;width:100%;max-height:240px;overflow:auto;border:1px solid #e8e8e8;border-top:none;border-bottom-left-radius:5px;border-bottom-right-radius:5px;z-index:1;-webkit-overflow-scrolling:touch}.multiselect__content{list-style:none;display:inline-block;padding:0;margin:0;min-width:100%}.multiselect--above .multiselect__content-wrapper{bottom:100%;border-bottom-left-radius:0;border-bottom-right-radius:0;border-top-left-radius:5px;border-top-right-radius:5px;border-bottom:none;border-top:1px solid #e8e8e8}.multiselect__content::webkit-scrollbar{display:none}.multiselect__element{display:block}.multiselect__option{display:block;padding:12px;min-height:40px;line-height:16px;text-decoration:none;text-transform:none;vertical-align:middle;position:relative;cursor:pointer;white-space:nowrap}.multiselect__option:after{top:0;right:0;position:absolute;line-height:40px;padding-right:12px;padding-left:20px}.multiselect__option--highlight{background:#41b883;outline:none;color:#fff}.multiselect__option--highlight:after{content:attr(data-select);background:#41b883;color:#fff}.multiselect__option--selected{background:#f3f3f3;color:#35495e;font-weight:700}.multiselect__option--selected:after{content:attr(data-selected);color:silver}.multiselect__option--selected.multiselect__option--highlight{background:#ff6a6a;color:#fff}.multiselect__option--selected.multiselect__option--highlight:after{background:#ff6a6a;content:attr(data-deselect);color:#fff}.multiselect--disabled{background:#ededed;pointer-events:none}.multiselect--disabled .multiselect__current,.multiselect--disabled .multiselect__select,.multiselect__option--disabled{background:#ededed;color:#a6a6a6}.multiselect__option--disabled{cursor:text;pointer-events:none}.multiselect__option--disabled.multiselect__option--highlight{background:#dedede!important}.multiselect-enter-active,.multiselect-leave-active{transition:all .15s ease}.multiselect-enter,.multiselect-leave-active{opacity:0}.multiselect__strong{margin-bottom:10px;display:inline-block}@keyframes a{0%{transform:rotate(0)}to{transform:rotate(2turn)}}
</style>
