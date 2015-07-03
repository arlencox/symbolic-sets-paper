library(plyr)
strace <- read.csv("output_strace.csv")
#stracea <- ddply(.data=strace, c("test", "config"), summarise, time = mean(time))

sdsl <- read.csv("output_sdsl.csv")

# process memcad results
memcad <- strace[which(grepl("\\.c", strace$test)),]
memcad_sat <- ddply(.data=memcad, c("test","config"), summarise, satc=max(satc), satt=max(satt), time=mean(time))
memcad_sat_na <- memcad_sat[which(is.na(memcad_sat$satc)),]
memcad_sat_nna <- memcad_sat[which(!is.na(memcad_sat$satc)),]
memcad_totals_nna <- ddply(.data=memcad_sat_nna, c("config"), summarize, satc=sum(satc), satt=sum(satt), time=sum(time))
memcad_totals_na <- count(memcad_sat_na, c("config"))
memcad_totals <- merge(x=memcad_totals_nna,y=memcad_totals_na, by="config", all = TRUE)
memcad_totals[is.na(memcad_totals)] <- 0
memcad_result <- memcad_totals[which(!grepl("bdd-x-full",memcad_totals$config) & !grepl("bdd-full",memcad_totals$config) & !is.na(memcad_totals$satt) & (!grepl("bdd-cudd",memcad_totals$config) | grepl("remap",memcad_totals$config))),]
memcad_result <- rename(memcad_result, c("satc"="memcad_prove", "satt"="memcad_total", "time"="memcad_time", "freq"="memcad_to"))


# process jsana results
jsana <- strace[which(grepl("-js",strace$test)),]
jsana_sat <- ddply(.data=jsana, c("test","config"), summarise, satc=max(satc), satt=max(satt), time=mean(time))
jsana_sat_na <- jsana_sat[which(is.na(jsana_sat$satc)),]
jsana_sat_nna <- jsana_sat[which(!is.na(jsana_sat$satc)),]
jsana_totals_nna <- ddply(.data=jsana_sat_nna, c("config"), summarize, satc=sum(satc), satt=sum(satt), time=sum(time))
jsana_totals_na <- count(jsana_sat_na, c("config"))
jsana_totals <- merge(x=jsana_totals_nna,y=jsana_totals_na, by="config", all = TRUE)
jsana_totals[is.na(jsana_totals)] <- 0
jsana_result <- jsana_totals[which(!grepl("bdd-x-full",jsana_totals$config) & !grepl("bdd-full",jsana_totals$config) & !is.na(jsana_totals$satt) & (!grepl("bdd-cudd",jsana_totals$config) | grepl("remap",jsana_totals$config))),]
jsana_result <- rename(jsana_result, c("satc"="jsana_prove", "satt"="jsana_total", "time"="jsana_time", "freq"="jsana_to"))

# process sdsl results
python <- sdsl[which(grepl("sa-",sdsl$test)),]
python[is.na(python$pass),]$pass <- 0
python[is.na(python$fail),]$fail <- 0
python$satt <- python$pass + python$fail
python$satc <- python$pass
python_sat <- ddply(.data=python, c("test","config"), summarise, satc=max(satc), satt=max(satt), time=mean(time))
python_sat_na <- python_sat[which(is.na(python_sat$time)),]
python_sat_nna <- python_sat[which(!is.na(python_sat$time)),]
python_totals_nna <- ddply(.data=python_sat_nna, c("config"), summarize, satc=sum(satc), satt=sum(satt), time=sum(time))
python_totals_na <- count(python_sat_na, c("config"))
python_totals <- merge(x=python_totals_nna,y=python_totals_na, by="config", all = TRUE)
python_totals[is.na(python_totals)] <- 0
python_result <- python_totals[which(!grepl("bdd-x-full",python_totals$config) & !grepl("bdd-full",python_totals$config) & !is.na(python_totals$satt) & (!grepl("bdd-cudd",python_totals$config) | grepl("remap",python_totals$config))),]
python_result <- rename(python_result, c("satc"="python_prove", "satt"="python_total", "time"="python_time", "freq"="python_to"))

result <- merge(x=merge(x=memcad_result,y=jsana_result), y=python_result)


result$config <- gsub(">","",result$config)
result$config <- gsub("-cudd","",result$config)
result$config <- gsub("remap<","",result$config)
result$config <- gsub("sing<","",result$config)
result$config <- gsub("<","+",result$config)
write.table(result, row.names=FALSE, col.names=FALSE, eol=" \\\\\n ", quote=FALSE, sep = " & ")
