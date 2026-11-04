<?php

namespace App\Filament\Resources\Slides\Schemas;

use Filament\Forms\Components\DatePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Schemas\Schema;

class SlideForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Slide Information'))
                    ->components([
                        TextInput::make('title')
                            ->label(__('Slide Title'))
                            ->required()
                            ->maxLength(255),
                        TextInput::make('link_url')
                            ->label(__('URL Link (Optional)'))
                            ->placeholder('https://...')
                            ->url(),
                        Textarea::make('description')
                            ->label(__('Description / Note'))
                            ->rows(2)
                            ->columnSpanFull(),
                    ])
                    ->columns(2),

                Section::make(__('Media & Scheduling'))
                    ->components([
                        FileUpload::make('image')
                            ->label(__('Slide Banner Image'))
                            ->image()
                            ->disk('public')
                            ->directory('slides')
                            ->required()
                            ->maxSize(3072)
                            ->columnSpanFull(),
                        DatePicker::make('start_date')
                            ->label(__('Display Start Date')),
                        DatePicker::make('end_date')
                            ->label(__('Display End Date')),
                        TextInput::make('sort_order')
                            ->label(__('Sort Order'))
                            ->numeric()
                            ->default(0),
                        Toggle::make('is_active')
                            ->label(__('Active Status'))
                            ->default(true),
                    ])
                    ->columns(2),
            ]);
    }
}
