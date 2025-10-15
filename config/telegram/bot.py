#!/usr/bin/env python3
import os
import asyncio
import logging
from telegram import Bot
from telegram.ext import Application, CommandHandler, MessageHandler, filters
import docker

# Configuration
TOKEN = os.getenv('TELEGRAM_BOT_TOKEN')
CHAT_ID = os.getenv('TELEGRAM_CHAT_ID')
HOMELAB_URL = os.getenv('HOMELAB_URL')

# Initialize Docker client
docker_client = docker.from_env()

# Logging setup
logging.basicConfig(
    format='%(asctime)s - %(name)s - %(levelname)s - %(message)s',
    level=logging.INFO
)

async def start(update, context):
    await update.message.reply_text(
        'Hello! I\'m your Homelab Bot. Available commands:\n'
        '/status - Check service status\n'
        '/services - List all services\n'
        '/restart <service> - Restart a service\n'
        '/logs <service> - Get service logs'
    )

async def status(update, context):
    try:
        containers = docker_client.containers.list(all=True)
        running = len([c for c in containers if c.status == 'running'])
        total = len(containers)
        
        message = f"🚀 Homelab Status:\n"
        message += f"Services: {running}/{total} running\n"
        message += f"Dashboard: {HOMELAB_URL}\n\n"
        
        # Critical services check
        critical_services = ['traefik', 'plex', 'adguard', 'gluetun']
        for service in critical_services:
            try:
                container = docker_client.containers.get(service)
                status_icon = "✅" if container.status == 'running' else "❌"
                message += f"{status_icon} {service}: {container.status}\n"
            except docker.errors.NotFound:
                message += f"❌ {service}: not found\n"
                
        await update.message.reply_text(message)
    except Exception as e:
        await update.message.reply_text(f"Error checking status: {str(e)}")

async def services(update, context):
    try:
        containers = docker_client.containers.list(all=True)
        message = "📊 All Services:\n\n"
        
        for container in sorted(containers, key=lambda x: x.name):
            status_icon = "✅" if container.status == 'running' else "❌"
            message += f"{status_icon} {container.name}: {container.status}\n"
            
        await update.message.reply_text(message)
    except Exception as e:
        await update.message.reply_text(f"Error listing services: {str(e)}")

async def restart_service(update, context):
    if not context.args:
        await update.message.reply_text("Usage: /restart <service_name>")
        return
        
    service_name = context.args[0]
    try:
        container = docker_client.containers.get(service_name)
        await update.message.reply_text(f"🔄 Restarting {service_name}...")
        container.restart()
        await update.message.reply_text(f"✅ {service_name} restarted successfully")
    except docker.errors.NotFound:
        await update.message.reply_text(f"❌ Service {service_name} not found")
    except Exception as e:
        await update.message.reply_text(f"Error restarting {service_name}: {str(e)}")

async def get_logs(update, context):
    if not context.args:
        await update.message.reply_text("Usage: /logs <service_name>")
        return
        
    service_name = context.args[0]
    try:
        container = docker_client.containers.get(service_name)
        logs = container.logs(tail=20).decode('utf-8')
        
        # Split logs if too long
        if len(logs) > 4000:
            logs = logs[-4000:]
            
        await update.message.reply_text(f"📋 Last 20 lines from {service_name}:\n\n```\n{logs}\n```", parse_mode='Markdown')
    except docker.errors.NotFound:
        await update.message.reply_text(f"❌ Service {service_name} not found")
    except Exception as e:
        await update.message.reply_text(f"Error getting logs for {service_name}: {str(e)}")

async def send_notification(message):
    """Send notification to Telegram"""
    bot = Bot(token=TOKEN)
    await bot.send_message(chat_id=CHAT_ID, text=message)

def main():
    application = Application.builder().token(TOKEN).build()
    
    application.add_handler(CommandHandler("start", start))
    application.add_handler(CommandHandler("status", status))
    application.add_handler(CommandHandler("services", services))
    application.add_handler(CommandHandler("restart", restart_service))
    application.add_handler(CommandHandler("logs", get_logs))
    
    print("Telegram bot started...")
    application.run_polling()

if __name__ == '__main__':
    main()
