library(dplyr)

dat <- readRDS("./data/map_data_final.rds")
codes <- readr::read_csv("./data/codes.csv")

### check country names for matches with topo ----
countries <- read.delim(
  "https://gist.githubusercontent.com/mbostock/4090846/raw/07e73f3c2d21558489604a0bc434b3a5cf41a867/world-country-names.tsv"
)

dat %>%
  group_by(Study_country) %>%
  summarize(n = n()) %>%
  left_join(countries, by = c("Study_country"="name")) %>%
  filter(is.na(id))

# use to verify in JavaScript
#dat %>%
#  group_by(Study_country, id) %>%
#  summarize(n = length(unique(aid))) %>%
#  arrange(desc(n))

# manual adjust NA
dat$country <- dat$Study_country
replace_country <- function(orig, repl) {
  dat[which(dat$country==orig), "country"] <- repl
  dat
}
dat <- replace_country("Bolivia", "Bolivia, Plurinational State of")
dat <- replace_country("Congo, The Democratic Republic Of The", "Congo, the Democratic Republic of the")
#cote de ivorie dat <- replace_country("","")
dat <- replace_country("Iran, Islamic Republic Of","Iran, Islamic Republic of")
dat <- replace_country("Saint Vincent And The Grenadines","Saint Vincent and the Grenadines")
dat <- replace_country("Taiwan, Province Of China","Taiwan, Province of China")
dat <- replace_country("Tanzania, United Republic Of","Tanzania, United Republic of")
dat <- replace_country("Venezuela", "Venezuela, Bolivarian Republic of")

dat <- dat %>%
  left_join(countries, by = c("country"="name")) %>%
  select(-country)

get_first <- function(row) {
  head(row,1)
}

dat %>%
  group_by(aid) %>%
  # match profor col names
  rename(Out_subtype = Outcome) %>%
  rename(Comps_type = Comps.type) %>%
  rename(Study_country.x = Study_country) %>%
  summarize(
    geo = list(unique(tibble(
      Study_country.x,
      id,
      region,
      subregion
    ))),
    outcome = list(unique(tibble(
      Out_subtype
    ))),
    intervention = list(unique(tibble(
      int_group,
      Int_type
    ))),
    habitat = list(unique(tibble(
      Biome.
    ))),
    comparator = list(unique(tibble(
      Comps_type
    )))
  ) %>%
  ungroup() %>%
  # join back columns with one value per articl
  inner_join(
    dat  %>%
      select(
        # the following will be summarized so that
        #  we will have one row for each article
        # remove geographic columns
        -Study_country, -id, -region, -subregion,
        # remove outcome columns
        -Outcome,
        # remove intervention
        -int_group,
        -Int_type,
        # remove habitat/biome
        -Biome.,
        # remove comparator
        -Comps.type
      ) %>%
      group_by(aid) %>%
      summarise_all(funs(get_first)) %>%
      ungroup(),
    by=c("aid"="aid")
  ) %>%
  rename(study = study_type) %>%
  select(
    aid, Authors, Pub_year, geo, outcome, intervention, study,
    everything()
  ) %>%
  {
    colnames(.) <- gsub(x=colnames(.), pattern="\\.", replacement="_")
    .
  } %>%
  jsonlite::toJSON(dataframe="rows", na="string") %>%
  cat(file="../../profor2_ebc/static/data_profor.json")



unique(dat[,c("region","subregion")]) %>%
{
  bind_rows(
    data_frame(
      region = c("NA","NA"),
      subregion = c(NA,"NA")
    ),
    .
  ) 
} %>%
{
  bind_rows(
    data_frame(
      region = .$region
    ),
    .
  )
} %>%
  arrange(region, subregion) %>%
  mutate(id = paste0("geo",1:n())) %>%  
  {  
    cat(
      sprintf(
        "
        export default function() {
        var data = %s;
        data.name = 'Geo';
        data.id = 'geo0'
        return data;
        }
        "
        ,d3r::d3_nest(., value_cols = "id")
      ),
      file="../../profor2_ebc/static/geofilters.js"
    )
  }


dat %>%
  select(Biome.) %>%
  unique() %>%
  left_join(codes, by=c("Biome." = "code")) %>%
  mutate(habitat = unlist(lapply(code_def,function(x){strsplit(x,"-")[[1]][1]}))) %>%
  mutate(ecoregion = unlist(lapply(code_def,function(x){strsplit(x,"-")[[1]][2]}))) %>%
  rename(code = Biome.) %>%
  select(habitat, ecoregion, code ) %>%
  {
    bind_rows(
      data_frame(
        habitat = c("NA","NA"), 
        ecoregion = c(NA,"NA"),
        code = "NA"
      ),
      .
    )
  } %>%
  {
    bind_rows(
      data_frame(
        habitat = .$habitat
      ),
      .
    )
  } %>%
  arrange(desc(habitat), ecoregion) %>%
  mutate(id = paste0("habitat",1:n())) %>%
  {
    cat(
      sprintf(
        "
        export default function() {
        var data = %s;
        data.id = 'habitat0';
        data.name = 'Habitat';
        return data;
        }
        "
        ,d3r::d3_nest(., value_cols=c("code","id"))
      ),
      file="../../profor2_ebc/src/habitatfilters.js"
    )    
    }



unique(dat[,c("int_group","Int_type")]) %>%
  left_join(codes, by=c("int_group"="code")) %>%
  mutate(group=code_def, group_code=int_group) %>%
  select(group, group_code, Int_type) %>%
  left_join(codes, by=c("Int_type"="code")) %>%
  mutate(type=code_def, type_code=Int_type) %>%
  select(group, type, type_code) %>%
  unique() %>%
  {
    bind_rows(
      data_frame(
        group = "NA",
        type = c(NA, "NA"),
        type_code = c(NA, "NA")
      ),
      .
    )
  } %>%
  {
    bind_rows(
      data_frame(
        group = .$group
      ),
      .
    )
  } %>%
  arrange(group, type)  %>%
  mutate(id = paste0("intervention",1:n())) %>%
  {
    cat(
      sprintf(
        "
        export default function() {
        var data = %s;
        data.id = 'intervention0';
        data.name = 'Intervention';
        return data;
        }
        "
        ,d3r::d3_nest(., value_cols=c("type_code","id"))
      ),
      file="../../profor2_ebc/src/interventionfilters.js"
    )    
    }


data_frame(outcome=unique(dat[,c("Outcome")])) %>%
  left_join(codes, by=c("outcome"="code")) %>%
  mutate(code=outcome, name=code_def) %>%
  unique() %>%
  mutate(id=paste0("outcome",1:n()), colname="outcome") %>%
  select(name, code, id, colname) %>%
  filter(!is.na(code)) %>%
  bind_rows(
    data.frame(
      name = "NA",
      code = "NA",
      id = paste0("outcome",nrow(.) + 1),
      colname = "outcome",
      stringsAsFactors = FALSE
    )
  ) %>%
  {
    cat(
      sprintf(
"
export default function() {
  var data = {
    id: 'outcome0',
    name: 'Outcome',
    children: %s
  };
  return data;
}
"
        ,jsonlite::toJSON(., dataframe="rows")
      ),
      file="../../profor2_ebc/src/outcomefilters.js"
    )
  }

codes <- codes %>%
  bind_rows(data.frame(
    code = "CGBA",
    code_def = "Comparison group, before/after",
    stringsAsFactors = FALSE
  ))

data_frame(study=unique(dat[,c("study_type")])) %>%
  left_join(codes, by=c("study"="code")) %>%
  mutate(code=study, name=code_def) %>%
  unique() %>%
  mutate(id=paste0("study",1:n()), colname="study") %>%
  select(name, code, id, colname) %>%
  filter(!is.na(code)) %>%
  bind_rows(
    data.frame(
      name = "NA",
      code = "NA",
      id = paste0("study",nrow(.) + 1),
      colname = "study",
      stringsAsFactors = FALSE
    )
  ) %>%
  {
    cat(
      sprintf(
"
export default function() {
  var data = {
    id: 'study0',
    name: 'Study Type',
    children: %s
  };
  return data;
}
"
        ,jsonlite::toJSON(., dataframe="rows")
      ),
      file="../../profor2_ebc/src/studyfilters.js"
    )
  }


data_frame(comp=unique(dat[,c("Comps.type")])) %>%
  mutate(code=comp, name=comp) %>%
  unique() %>%
  mutate(id=paste0("comparator",1:n())) %>%
  mutate(colname="comparator") %>%
  select(name, code, id, colname) %>%
  filter(!is.na(code)) %>%
  bind_rows(
    data.frame(
      name = "NA",
      code = "NA",
      id = paste0("comparator",nrow(.) + 1),
      colname = "comparator",
      stringsAsFactors = FALSE
    )
  ) %>%
  {
    cat(
      sprintf(
"
export default function() {
  var data = {
    id: 'comparator0',
    name: 'Comparator',
    children: %s
  };
  return data;
}
"
  ,jsonlite::toJSON(., dataframe="rows")
      ),
file="../../profor2_ebc/src/compfilters.js"
    )
  }




codes %>%
  {
    cat(
      sprintf(
  "
  export default function() {
    var data = %s;
    return data;
  }
  ",
        jsonlite::toJSON(., dataframe="rows")
      ),
      file = "../../profor2_ebc/src/codes.js"
    )
  }


dat %>%
  select(int_group, Outcome, aid) %>%
  unique() %>%
  #group_by(int_group, Outcome, aid) %>%
  #do(head(.,1)) %>%
  count(int_group, Outcome, sort=TRUE)

library(d3hierR)
library(d3r)

dat %>%
  select(int_group, Outcome, aid) %>%
  unique() %>%
  #group_by(int_group, Outcome, aid) %>%
  #do(head(.,1)) %>%
  count(int_group, Outcome, sort=TRUE) %>%
  d3_nest(value_cols = "n") %>%
  tree(
    sizeField = "n", paddingOuter=15, clipText=TRUE,
    height=800, styleText = list("font-size" = "70%")
  )

dat %>%
  select(int_group,region, Study_country, aid) %>%
  unique() %>%
  count(int_group,region, Study_country, sort=TRUE) %>%
  d3_nest(value_cols = "n") %>%
  tree(
    sizeField = "n", paddingOuter=15, clipText=TRUE,
    tile = htmlwidgets::JS("d3.treemapBinary"),
    height=800, styleText = list("font-size" = "70%")
  )

dat %>%
  select(int_group,region, Study_country, aid) %>%
  unique() %>%
  count(int_group,region, Study_country, sort=TRUE) %>%
  d3_nest(value_cols = "n") %>%
  tree(
    sizeField = "n", paddingOuter=15, clipText=TRUE,
    tile = htmlwidgets::JS("d3.treemapSliceDice"),
    height=800, styleText = list("font-size" = "70%")
  )

dat %>%
  select(region, Study_country, aid) %>%
  unique() %>%
  count(region, Study_country, sort=TRUE) %>%
  d3_nest(value_cols = "n") %>%
  tree(
    sizeField = "n", paddingOuter=15, clipText=TRUE,
    height=800, styleText = list("font-size" = "70%")
  )


# how would we make network out of this
library(igraph)
ig <- dat %>%
  select(int_group, region, aid) %>%
  unique() %>%
  count(int_group, region, sort=TRUE) %>%
  {graph_from_data_frame(
    .,
    directed = FALSE
  )}


library(rpivotTable)
rp <- rpivotTable(
  dat,
  aggregatorName = "Count Unique Values",
  vals = "aid",
  rows = c("Int_type", "region"),
  cols = c("Outcome"), 
  subtotals = TRUE
)

