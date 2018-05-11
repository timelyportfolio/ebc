<template>
  <div class="col-12" style="margin-top:15px;">
    <p>
      Below you will fill links to download custom, filtered datasets based on your chosen parameters.
      Data is available to download in two formats, 1) JSON (JavaScript Object Notation) and
      2) CSV (comma-separated values). Both formats can be viewed and edited in a text editor.
      CSV files can be opened in Excel or another spreadsheet program.
    </p>
    <p>
      Please ensure that you properly cite any data you use from this study.
    </p>
    <button v-on:click="downloadJson">Download JSON</button>
    <button v-on:click="downloadCsv">Download Excel (CSV)</button>
    <registration
     :visible = "registrationVisible"
     @registerComplete = "handleRegister"
     @close = "handleClose"
    ></registration>
  </div>
</template>

<script>
  import {csv} from 'd3-request'
  import {csvFormat} from 'd3-dsv'
  import Registration from '../../components/Registration.vue'

  export default {
    components: {
      Registration
    },
    props: ['fulldata', 'filtered', 'checkedfilters'],
    data: function() {
      return {
        registrationVisible: false,
        registered: false,
        downloading: "none"
      }
    },
    methods: {
      handleRegister: function() {
        this.registered = true
        this.registrationVisible = false
        if(this.downloading==="json") { this.downloadJson() }
        if(this.downloading==="csv") { this.downloadCsv() }
      },
      handleClose: function() {
        this.registrationVisible = false
      },
      // https://stackoverflow.com/questions/14964035/how-to-export-javascript-array-info-to-csv-on-client-side
      // The download function takes a CSV string, the filename and mimeType as parameters
      download: function(content, fileName, mimeType) {
        var a = document.createElement('a');
        mimeType = mimeType || 'application/octet-stream';

        if (navigator.msSaveBlob) { // IE10
          navigator.msSaveBlob(new Blob([content], {
            type: mimeType
          }), fileName);
        } else if (URL && 'download' in a) { //html5 A[download]
          a.href = URL.createObjectURL(new Blob([content], {
            type: mimeType
          }));
          a.setAttribute('download', fileName);
          document.body.appendChild(a);
          a.click();
          document.body.removeChild(a);
        } else {
          location.href = 'data:application/octet-stream,' + encodeURIComponent(content); // only this mime type is supported
        }
      },
      downloadJson: function(fileName) {
        if(!this.registered) {
          this.downloading = "json"
          this.registrationVisible = true
          return
        }
        var content = JSON.stringify(this.filtered.data);
        this.download(content, "profor.json", "application/json");
      },
      downloadCsv: function(fileName) {
        if(!this.registered) {
          this.downloading = "csv"
          this.registrationVisible = true
          return
        }
        // load our static csv data and then filter to match applied filters
        //   then wrap it all up and send it to the user
        var thisvue = this
        var filterids = this.filtered.data.map(function(d) {return d.aid})
        csv('./static/data_profor.csv', function(error, data) {
          var filtered = data.filter(function(d) {
            return filterids.indexOf(+d.aid) > -1
          })

          thisvue.download(
            csvFormat(filtered, Object.keys(filtered[0])),
            "profor.csv",
            "text/csv"
          )
        })
      }
    }
  }
</script>
