#!/usr/bin/python
# -*- coding: utf-8  -*-

import json
import urllib3
from telegram.ext import Updater, MessageHandler, Filters, CommandHandler  # import modules
import esbot

my_token = ''
print('start telegram chat bot')

def es_command(bot, update) :
    cmd = update.message.text.split(" ")
    rtn = esbot.es(cmd)

    update.message.reply_text(rtn)

updater = Updater(my_token)

es_handler = CommandHandler('es', es_command)
updater.dispatcher.add_handler(es_handler)

updater.start_polling(timeout=3, clean=True)
updater.idle()
