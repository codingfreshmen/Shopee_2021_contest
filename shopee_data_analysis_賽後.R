#### 重新在寫一次
library(tidyverse)
#view(head(result))
customer <- read.csv("/users/andychang/desktop/contacts.csv")
customer$Email <- as.character(customer$Email)
customer$Email[customer$Email == ""] <- NA
customer$OrderId <- as.character(customer$OrderId)
customer$OrderId[customer$OrderId == ""] <- NA
customer <- customer %>% fill(c("Email","OrderId"))
customer[1,ncol(customer)] <- customer[2,ncol(customer)]
customer$ticket_id <- customer$Id
#### 先把contacts計算出來
customer_contact <- customer %>% group_by(Email) %>% summarise(ticket_trace = sum(Contacts))
customer_combine <- merge(customer[,-c(1,4)], customer_contact, by.x = c("Email"), by.y = c("Email"))
### testing
customer_contact_1 <- customer_combine %>% group_by(Email) %>% summarise(ticket_contacts = paste(Id, collapse = "-"))
customer_final <- merge(customer_combine, customer_contact_1, by.x = c("Email"), by.y = c("Email"))
customer_final <- customer_final[,c(5,7,6)]
customer_final <- customer_final %>% 
  unite(ticket_contacts, ticket_trace,col = "ticket_trace/contacts",sep = "-") %>%
  arrange(ticket_id)
nrow(customer_final)
customer_final[1:50,]
write.csv(customer_final, file = 'result.csv')

