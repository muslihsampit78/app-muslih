<?php

namespace App\Filament\Resources\Posts\Schemas;

use App\Enums\PostStatus;
use Filament\Forms\Components\DateTimePicker;
use Filament\Forms\Components\FileUpload;
use Filament\Forms\Components\Hidden;
use Filament\Forms\Components\RichEditor;
use Filament\Forms\Components\Section;
use Filament\Forms\Components\Select;
use Filament\Forms\Components\Textarea;
use Filament\Forms\Components\TextInput;
use Filament\Forms\Components\Toggle;
use Filament\Forms\Set;
use Filament\Schemas\Schema;
use Illuminate\Support\Str;

class PostForm
{
    public static function configure(Schema $schema): Schema
    {
        return $schema
            ->components([
                Section::make(__('Main Content'))
                    ->columnSpan(['lg' => 2])
                    ->components([
                        TextInput::make('title')
                            ->label(__('Article Title'))
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
                        Textarea::make('summary')
                            ->label(__('Summary / Synopsis'))
                            ->rows(3)
                            ->helperText(__('Short summary for news preview card display.')),
                        RichEditor::make('content')
                            ->label(__('Full Article Content'))
                            ->required()
                            ->columnSpanFull(),
                    ]),

                Section::make(__('Publication & Settings'))
                    ->columnSpan(['lg' => 1])
                    ->components([
                        Select::make('category_id')
                            ->label(__('Category'))
                            ->relationship('category', 'name')
                            ->searchable()
                            ->preload()
                            ->required(),
                        FileUpload::make('image')
                            ->label(__('Cover Image (Thumbnail)'))
                            ->image()
                            ->disk('public')
                            ->directory('posts')
                            ->maxSize(2048),
                        Select::make('status')
                            ->label(__('Status'))
                            ->options(collect(PostStatus::cases())->mapWithKeys(fn (PostStatus $status) => [
                                $status->value => $status->label(),
                            ]))
                            ->default(PostStatus::Draft->value)
                            ->required(),
                        DateTimePicker::make('published_at')
                            ->label(__('Publication Time'))
                            ->default(now()),
                        Toggle::make('is_featured')
                            ->label(__('Featured Article / Headline'))
                            ->default(false),
                        Hidden::make('user_id')
                            ->default(fn () => auth()->id()),
                    ]),
            ])
            ->columns(3);
    }
}
