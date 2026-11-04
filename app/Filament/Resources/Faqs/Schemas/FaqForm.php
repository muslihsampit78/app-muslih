<?php

namespace App\Filament\Resources\Faqs\Schemas;

use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class FaqForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Select::make('topic_id')
                    ->label(__('FAQ Topic'))
                    ->relationship('topic', 'name')
                    ->searchable()
                    ->preload(),
                TextInput::make('question')
                    ->label(__('Question (FAQ)'))
                    ->required()
                    ->columnSpanFull(),
                RichEditor::make('answer')
                    ->label(__('Answer'))
                    ->required()
                    ->columnSpanFull(),
                TextInput::make('sort_order')
                    ->label(__('Display Order'))
                    ->numeric()
                    ->default(0),
                Toggle::make('is_active')
                    ->label(__('Active Status'))
                    ->default(true),
            ]);
    }
}
