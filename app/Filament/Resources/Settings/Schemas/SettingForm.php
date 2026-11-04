<?php

namespace App\Filament\Resources\Settings\Schemas;

use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Schemas\Schema;

class SettingForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('group')
                    ->label(__('Group'))
                    ->options([
                        'general' => __('General'),
                        'contact' => __('Contact'),
                        'social' => __('Social Media'),
                        'system' => __('System'),
                    ])
                    ->default('general')
                    ->required(),
                TextInput::make('key')
                    ->label(__('Key'))
                    ->required()
                    ->unique(ignoreRecord: true)
                    ->helperText(__('Example: site_name, contact_email')),
                TextInput::make('name')
                    ->label(__('Label Name'))
                    ->required(),
                Select::make('type')
                    ->label(__('Data Type'))
                    ->options([
                        'text' => __('Short Text'),
                        'textarea' => __('Long Text'),
                        'image' => __('Image / Logo'),
                        'boolean' => __('Boolean (True/False)'),
                        'json' => __('JSON'),
                    ])
                    ->default('text')
                    ->reactive()
                    ->required(),
                Textarea::make('value')
                    ->label(__('Setting Value'))
                    ->rows(4)
                    ->columnSpanFull(),
                Textarea::make('description')
                    ->label(__('Description / Note'))
                    ->rows(2)
                    ->columnSpanFull(),
            ]);
    }
}
