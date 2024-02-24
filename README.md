# K6504-SBC

## 概要

* R6504 CPU(6502 CPUの仲間)を使ったシングルボードコンピューターです。
  * アドレシングできる範囲は8kBです。
  * RAM4kB、ROM3kB UniversanMonitorを動かすのが目標です

## 回路図

![](image/K6504-SBC.jpg)

## 部品表

[KiCAD/K6504-SBC.csv](KiCAD/K6504-SBC.csv)

## 注意点

* シリアルIC(6551)、RAM/IO/TIMER IC(6532)の割り込み信号線は、基板裏のソルダージャンパーをはんだで短絡すると有効になります。