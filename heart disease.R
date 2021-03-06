
Title<- "predicting heart diesease"
author<- "Anurag Yadav"

##**Heart disease** is a general term that means that the heart is not 
#working normally. The majority of heart diseases are non-communicable
#and related to lifestyle , ageing and other factors. Heart disease is
#the biggest killer of both men and women in the United States, England
#and Canada. For example, heart disease causes 4 out of every 10 deaths
#in the United States. This is more than all kinds of cancer put together.
#On an average 30% of all deaths in 2008 were beacuse of heart diseases. 
#This rate varies from a lower 28% to a high 40% in high-income countries.
#A person can have heart disease and not feel sick. Some people with heart
#disease have symptoms. This is when there are changes or pain in the body 
#to show a disease is there. Some symptoms of heart disease are:
#**Sex** : 1 = Male , 0 = Female

#**cp** : Chest pain type (0 - 3)

#**trestbps** : Resting blood pressure (in mm Hg on admission to the hospital)

#**chol** : Serum cholesterol in mg/dl

#**fbs** : Fasting blood sugar > 120 mg/dl (1 = true , 0 = false)

#**restecg** : Resting electrocardiographic results (0-2)

#**exang**  : Exercise induced angina (1 = yes , 0 = no)

#**oldpeak**  : ST depression induced by exercise relative to rest

#**slope**  : The slope of the peak exercise ST segment (0-2)

## libraries used 
library(dplyr)
library(tidyr)
library(ggplot2)
library(caTools)
library(DataExplorer)
library(caret)
library(pROC)
## loading data
df<-read.csv('heart.csv')
head(df)
View(df)
## eda
summary(df)
## categorical variables
colnames(df)
## 'sex','chestpaintype',RestingECG , "ST_Slope","HeartDisease'
## we have 5 categorical variables 
str(df)
## data cleaning
df$Sex= as.factor(df$Sex)
df$ChestPainType=as.factor(df$ChestPainType)
df$RestingECG=as.factor(df$RestingECG)
df$ExerciseAngina= as.factor(df$ExerciseAngina)
df$ST_Slope= as.factor(df$ST_Slope)
## for heart disease we'll use different thing
which(is.na(df))
## our data doesn't contain any NA which is a good thing but we can't explore data cleaning here so no learning
## but if data have NA then we'll try to make it zero or remove that rows
df$HeartDisease= ifelse(df$HeartDisease==0,"healthy","unhealty")
str(df)
df$HeartDisease=as.factor(df$HeartDisease)
###Objective of the analysis is to build a binary model for the
##target variable that will predict the levels (out of 0, 1)(heart risk)
##based on the given risk factors with a good accuracy.
boxplot(RestingBP~HeartDisease ,df)
boxplot(FastingBS~HeartDisease,df)
boxplot(Age~HeartDisease,df)
boxplot(Oldpeak~HeartDisease,df)
boxplot(HeartDisease~factor(ChestPainType),df)

## barplot for categorical variables
library(ggplot2)
ggplot(df,aes(Sex,HeartDisease))+ geom_bar(stat = 'identity',aes(fill=HeartDisease))
ggplot(df,aes(ChestPainType,HeartDisease))+ geom_bar(stat = 'identity',aes(fill=HeartDisease))
## linear regression
library(caTools)

install.packages("caTools")
set.seed(124)
samp<-sample.split(df$HeartDisease,SplitRatio = 0.7)
sum(samp)/(sum(samp==TRUE)+sum(samp==FALSE))
train= subset(df,samp==TRUE)
test= subset(df,samp== FALSE)
## model
## let's see how many males and females have disease
xtabs(~HeartDisease+Sex,df)
## since Sex is associated with heart disease so it is not advisable to remove females 
xtabs(~HeartDisease+ChestPainType,df)
## correlation plot
library(DataExplorer)
install.packages("DataExplorer")
plot_correlation(df[,c(1,4,5,6,8,10)])

##  fit logistic regression

mymod<-glm(HeartDisease~.,train,family="binomial")
mymod
# prediction on test data
predmod<-predict(mymod,test)
Predprob <- predict(mymod,test, type="response")
Predprob
install.packages("caret")
library(caret)
## confusion  matrix
pred_test <- ifelse( Predprob  >  0.5 , 1 , 0)
confmat<-table(test$HeartDisease,pred_test)

## ACCURACY
##right prediction/total prediction
## by confusion matrix
total_right_prediction= 99+135
total_wrong_prediction=17+24
accuracy=total_right_prediction/(total_right_prediction+total_wrong_prediction)
accuracy

