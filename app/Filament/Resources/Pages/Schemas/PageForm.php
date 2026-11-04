<?php

namespace App\Filament\Resources\Pages\Schemas;

use App\Enums\PageStatus;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PageForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Page Content'))
                    ->columnSpan(['lg' => 2])
                    ->components([
                        TextInput::make('title')
                            ->label(__('Page Title'))
                            ->required()
                            ->maxLength(255)
                            ->live(onBlur: true)
                            ->afterStateUpdated(function (string $operation, ?string $state, Set $set): void {
                                if ($operation === 'create' && filled($state)) {
                                    $set('slug', Str::slug($state));
                                }
                            }),
                        TextInput::make('slug')
                            ->label(__('Slug'))
                            ->required()
                            ->unique(ignoreRecord: true)
                            ->maxLength(255),
                        RichEditor::make('content')
                            ->label(__('Content'))
                            ->required()
                            ->columnSpanFull(),
                    ]),

                Section::make(__('Settings & Publication'))
                    ->columnSpan(['lg' => 1])
                    ->components([
                        FileUpload::make('image')
                            ->label(__('Banner / Header Image'))
                            ->image()
                            ->disk('public')
                            ->directory('pages')
                            ->maxSize(2048),
                        Select::make('status')
                            ->label(__('Status'))
                            ->options(collect(PageStatus::cases())->mapWithKeys(fn (PageStatus $s) => [
                                $s->value => $s->label(),
                            ]))
                            ->default(PageStatus::Published->value)
                            ->required(),
                        TextInput::make('sort_order')
                            ->label(__('Sort Order'))
                            ->numeric()
                            ->default(0),
                        Toggle::make('show_in_menu')
                            ->label(__('Show in Main Menu'))
                            ->default(false),
                        Hidden::make('user_id')
                            ->default(fn () => auth()->id()),
                    ]),
            ])
            ->columns(3);
    }
}
