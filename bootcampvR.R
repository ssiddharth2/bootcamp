covid19p<-read.csv('/Users/siddharthsurapaneni/bootcamp/bootcamp/us-counties.csv')

library(tidyverse)
covid19p$region= case_when(
  covid19p$state %in% c('Connecticut', 'Maine', 'Massachusetts', 'New Hampshire', 'Rhode Island', 'Vermont')~"New England",
  covid19p$state %in% c("New Jersey","New York","Pennsylvania")~"Mid Atlantic",
  covid19p$state %in% c("Illinois","Indiana","Michigan","Ohio","Wisconson")~"East North Central",
  covid19p$state %in% c("Iowa","Kansas","Minnesota","Missouri","Nebraska","North Dakota","South Dakota")~"West North Central",
  covid19p$state %in% c("Delaware","Florida","Georgia","Maryland","North Carolina","South Carolina","Virginia","District of Columbia","West Virginia")~"South Atlantic",
  covid19p$state %in% c("Alabama","Kentucky","Mississippi","Tennessee")~"East South Central",
  covid19p$state %in% c("Arkansas","Louisiana","Oklahoma","Texas")~"West South Central",
  covid19p$state %in% c("Alaska","California","Hawaii","Oregon","Texas")~"Pacific",
  TRUE~'Mountain'
)
covid19p$date<-as.Date(covid19p$date)
covid19p
covid19<-covid19p %>%
  group_by(region,date)%>%
  summarise(total=sum(cases))

covid19

ggplot(data=covid19)+geom_line(mapping = aes(x=date,y=total,colour=region))+ggtitle('Covid Cases by Region')+
  scale_y_continuous(labels=scales::comma)
