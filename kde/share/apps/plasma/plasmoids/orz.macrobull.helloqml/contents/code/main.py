# -*- coding: utf-8 -*-
from PyQt4.QtCore import *
from PyQt4.QtGui import *
from PyKDE4.plasma import Plasma
from PyKDE4 import plasmascript

class PowerChart(plasmascript.Applet):
   def __init__(self, parent, args=None):
       plasmascript.Applet.__init__(self, parent)

   def init(self):
       self.layout = QGraphicsGridLayout(self.applet)
       self.chart = Plasma.SignalPlotter(self.applet)
       self.chart.addPlot(QColor(0,255,0))
       self.layout.addItem(self.chart, 0, 0)
       self.setAspectRatioMode(Plasma.IgnoreAspectRatio)
       self.resize(200, 150)
       self.setHasConfigurationInterface(False)
       self.chart.setTitle("Battery Charge")
       self.connectToEngine()

   def connectToEngine(self):
       self.engine = self.dataEngine('soliddevice')
       battery = self.engine.query('IS Battery').values()[0].toString()
       print "Connecting to battery %s"%battery
       if not battery:
          print("you don't appear to have a battery.")
          [self.chart.addSample([v]) for v in [1,  2,  3,  1]]
       else:
          self.engine.connectSource(battery, self)

   @pyqtSignature("dataUpdated(const QString &, const Plasma::DataEngine::Data &)")
   def dataUpdated(self, sourceName, data):
       charge = data[QString("Charge Percent")]#.toInt()[0]
       print "Charge: %s%%"%charge
       samples = [charge,]
       self.chart.addSample(samples)

def CreateApplet(parent):
   return PowerChart(parent)